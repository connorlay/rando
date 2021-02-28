defmodule Rando.Server.State do
  @moduledoc false

  alias Rando.Accounts

  defstruct [:max_number, :queried_at, :users]

  def new() do
    %__MODULE__{
      max_number: random_number(),
      queried_at: nil,
      users: [],
    }
  end

  def query_for_users(state) do
    state
    |> update_queried_at()
    |> list_users()
  end

  def randomize_all_user_points(state) do
    Accounts.randomize_all_user_points()
    %__MODULE__{state | max_number: random_number()}
  end

  defp update_queried_at(state) do
    %__MODULE__{state | queried_at: NaiveDateTime.utc_now()}
  end

  defp list_users(state) do
    users = Accounts.list_users_limited_with_greater_than_points(state.max_number)
    %__MODULE__{state | users: users}
  end

  defp random_number() do
    :rand.uniform(100)
  end
end
