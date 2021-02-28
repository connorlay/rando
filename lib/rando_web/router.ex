defmodule RandoWeb.Router do
  use RandoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipe_through :api
  get "/", RandoWeb.UserController, :index
end
