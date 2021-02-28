defmodule Rando.Server do
  alias Rando.Server.State

  require Logger

  use GenServer

  # one minute
  @randomize_after 60 * 1000

  def start_link(opts) do
    randomize_after = Keyword.get(opts, :randomize_after, @randomize_after)
    GenServer.start_link(__MODULE__, randomize_after, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :query)
  end

  @impl true
  def init(randomize_after) do
    state = State.new()
    Logger.debug("[#{__MODULE__}] starting server state: '#{inspect(state)}'")
    Process.send_after(self(), :randomize, randomize_after)
    {:ok, {state, randomize_after}}
  end

  @impl true
  def handle_call(:query, _from, {state, randomize_after}) do
    Logger.debug("[#{__MODULE__}] query state: '#{inspect(state)}'")
    {:reply, state, {State.query_for_users(state), randomize_after}}
  end

  @impl true
  def handle_info(:randomize, {state, randomize_after}) do
    Logger.debug("[#{__MODULE__}] randomize state: '#{inspect(state)}'")
    Process.send_after(self(), :randomize, randomize_after)
    new_state = State.randomize_all_user_points(state)
    {:noreply, {new_state, randomize_after}}
  end
end
