defmodule RandoWeb.UserView do
  use RandoWeb, :view
  alias RandoWeb.UserView

  def render("index.json", %{users: users, queried_at: queried_at}) do
    %{users: render_many(users, UserView, "user.json"), queried_at: queried_at}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, points: user.points}
  end
end
