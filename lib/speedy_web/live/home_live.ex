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
       current_page: 1,
       paginated: false,
       people: People.list(limit: initial_amount),
       render_strategy: "default_comprehension",
       tick: 0
     )}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "update",
        %{
          "people" => %{
            "amount" => amount_input,
            "render_strategy" => render_strategy,
            "paginated" => paginated_input
          }
        },
        socket
      ) do
    amount = parse_amount(amount_input)

    {:noreply,
     assign(
       socket,
       amount: amount,
       paginated: parse_boolean(paginated_input),
       people: People.list(limit: amount),
       render_strategy: render_strategy
     )}
  end

  @impl true
  def handle_info(
        {:tick, tick_count},
        %Phoenix.LiveView.Socket{
          assigns: %{
            amount: amount
          }
        } = socket
      ) do
    Process.send_after(self(), {:tick, tick_count + 1}, 1000)
    Logger.debug("ticking #{tick_count} ⏰")

    {:noreply,
     assign(socket, people: People.list(limit: amount), tick: tick_count)}
  end

  def max_amount, do: 30000
  def min_amount, do: 1

  defp parse_amount(amount_input) do
    amount_input
    |> String.to_integer()
    |> min(max_amount())
    |> max(min_amount())
  end

  defp parse_boolean(boolean_input) do
    case boolean_input do
      "true" -> true
      "false" -> false
    end
  end
end
