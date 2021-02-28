defmodule Rando.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Rando.Repo

  alias Rando.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns a limited list of users who have points greater than `max_number`.
  """
  def list_users_limited_with_greater_than_points(max_number, limit \\ 2)
      when max_number in 0..100 and limit > 0 do
    query =
      from u in User,
        where: u.points > ^max_number,
        limit: ^limit

    Repo.all(query)
  end

  @doc """
  Randomizes all user points.

  Calls the custom `random_between(low INT, high INT)` pg function to avoid an N+1 query.
  """
  def randomize_all_user_points() do
    updated_at = NaiveDateTime.utc_now()

    query =
      from u in User,
        update: [
          set: [
            points: fragment("random_between(?,?)", 0, 100),
            updated_at: ^updated_at
          ]
        ]

    Repo.update_all(query, [])
  end
end
