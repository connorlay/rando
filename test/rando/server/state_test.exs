defmodule Rando.Server.StateTest do
  alias Rando.Accounts
  alias Rando.Accounts.User
  alias Rando.Server.State

  use Rando.DataCase, async: true

  setup do
    for i <- 1..10, do: Accounts.create_user(%{points: i})
    :ok
  end

  test "new/0 returns a fresh state" do
    state = State.new()
    assert state.max_number in 1..100
    refute state.queried_at
    assert state.users == []
  end

  test "query_for_users/1 updates the timestamp and users" do
    state = State.query_for_users(%{State.new() | max_number: 8})
    assert [%User{points: 9}, %User{points: 10}] = state.users
    assert state.queried_at
    new_state = State.query_for_users(state)
    assert NaiveDateTime.compare(new_state.queried_at, state.queried_at) == :gt
  end

  test "randomize_all_user_points/1 randomizes all user points and the max number" do
    state = State.new()
    assert Enum.map(Accounts.list_users(), & &1.points) == Enum.to_list(1..10)
    new_state = State.randomize_all_user_points(state)
    refute Enum.map(Accounts.list_users(), & &1.points) == Enum.to_list(1..10)
    refute new_state.max_number == state
  end
end
