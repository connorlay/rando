defmodule Rando.AccountsTest do
  use Rando.DataCase

  alias Rando.Accounts

  describe "users" do
    alias Rando.Accounts.User

    @valid_attrs %{points: 42}
    @invalid_attrs %{points: nil}
    @out_of_range_attrs [%{points: -1}, %{points: 101}]

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.points == 42
    end

    test "create_user/1 with invalid data returns a changeset error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)

      for attrs <- @out_of_range_attrs do
        assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
      end
    end

    test "list_users_limited_with_greater_than_points/2 returns up to :limited users with points greater than :max_number" do
      assert [] = Accounts.list_users_limited_with_greater_than_points(0)

      for points <- [0, 25, 50, 75, 100] do
        user_fixture(%{points: points})
      end

      assert [%User{points: 50}, %User{points: 75}] =
               Accounts.list_users_limited_with_greater_than_points(25)

      assert [%User{points: 75}, %User{points: 100}] =
               Accounts.list_users_limited_with_greater_than_points(50)

      assert [] = Accounts.list_users_limited_with_greater_than_points(100)
    end

    test "randomize_all_user_points/0 randomizes all user points in range 1..100" do
      users = for _ <- 1..10, do: user_fixture(%{points: 0})
      assert Enum.all?(users, &(&1.points == 0))
      Accounts.randomize_all_user_points()
      randomized_users = Accounts.list_users()
      refute randomized_users == users
      refute Enum.all?(randomized_users, &(&1.points == 0))
      assert Enum.all?(randomized_users, &(&1.points in 0..100))
    end
  end
end
