defmodule RandoWeb.UserController do
  use RandoWeb, :controller

  require Logger

  action_fallback RandoWeb.FallbackController

  def index(conn, _params) do
    state = Rando.Server.get_state()
    render(conn, "index.json", users: state.users, queried_at: state.queried_at)
  end
end
