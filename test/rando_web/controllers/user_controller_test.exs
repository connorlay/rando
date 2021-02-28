defmodule RandoWeb.UserControllerTest do
  use RandoWeb.ConnCase

  alias Rando.Accounts

  setup %{conn: conn} do
    for _ <- 1..100, do: Accounts.create_user()
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      assert %{"users" => [], "queried_at" => nil} ==
               conn
               |> get(Routes.user_path(conn, :index))
               |> json_response(200)

      # manually trigger server refresh
      send(Rando.Server, :randomize)

      assert %{"users" => users, "queried_at" => queried_at} =
               conn
               |> get(Routes.user_path(conn, :index))
               |> json_response(200)

      assert length(users) in 0..2
      assert Enum.all?(users, &(%{"id" => _, "points" => _} = &1))
      assert NaiveDateTime.from_iso8601!(queried_at)
    end
  end
end
