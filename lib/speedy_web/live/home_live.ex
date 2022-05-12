defmodule SpeedyWeb.HomeLive do
  require Logger
  use SpeedyWeb, :live_view
  alias Speedy.People

  @impl true
  def mount(_params, _session, socket) do
    initial_amount = 15
    send(self(), {:tick, 1})
    Logger.debug("Mount 🐴")

    {:ok,
     assign(
       socket,
       amount: initial_amount,
       tick: 0,
       people: People.generate(initial_amount)
     )}
  end

  @impl Phoenix.LiveView
  def handle_event("update", %{"amount" => input_amount}, socket) do
    amount = String.to_integer(input_amount)

    {:noreply,
     assign(
       socket,
       amount: amount,
       people: People.generate(amount)
     )}
  end

  def handle_info(
        {:tick, tick_count},
        %Phoenix.LiveView.Socket{
          assigns: %{
            people: people,
            amount: amount
          }
        } = socket
      ) do
    Process.send_after(self(), {:tick, tick_count + 1}, 1000)
    Logger.debug("ticking #{tick_count} ⏰")

    {:noreply,
     assign(socket, people: People.update(people, 15), tick: tick_count)}
  end
end
