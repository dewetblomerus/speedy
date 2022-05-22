defmodule Speedy.Ticker do
  use GenServer
  require Logger
  alias Speedy.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0)
  end

  @impl true
  def init(state) do
    Logger.debug("Starting the #{__MODULE__} at #{state} ⏰")
    :timer.send_interval(1000, :tick)
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, state) when state > 998 do
    send_tick_pubsub(state)
    {:noreply, 0}
  end

  @impl true
  def handle_info(:tick, state) do
    send_tick_pubsub(state)
    {:noreply, state + 1}
  end

  defp send_tick_pubsub(tick) do
    Phoenix.PubSub.broadcast(PubSub, "tick", {:tick, tick})
  end
end
