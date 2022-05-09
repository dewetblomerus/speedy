defmodule SpeedyWeb.HomeLive do
  use SpeedyWeb, :live_view
  alias Speedy.People

  @impl true
  def mount(_params, _session, socket) do
    initial_amount = 5

    {:ok,
     assign(
       socket,
       amount: initial_amount,
       people: People.generate(initial_amount)
     )}
  end

  @impl Phoenix.LiveView
  def handle_event("update", %{"amount" => input_amount}, socket) do
    IO.inspect(socket, label: "🔌")
    amount = String.to_integer(input_amount)

    {:noreply,
     assign(
       socket,
       amount: amount,
       people: People.generate(amount)
     )}
  end
end
