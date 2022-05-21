defmodule SpeedyWeb.HomeLive do
  require Logger
  use SpeedyWeb, :live_view
  alias Speedy.People
  @initial_amount 15

  @impl true
  def mount(_params, _session, socket) do
    Logger.debug("Mounting #{__MODULE__} 🐴")
    subscribe_tick_pubsub()

    {:ok,
     assign(
       socket,
       amount: @initial_amount,
       page: 1,
       paginate: false,
       people: People.list(limit: @initial_amount),
       render_strategy: "default_comprehension",
       tick: 0
     )}
  end

  def handle_params(
        params,
        _url,
        %Phoenix.LiveView.Socket{
          assigns: %{
            amount: amount,
            paginate: paginate
          }
        } = socket
      ) do
    page = String.to_integer(params["page"] || "1")

    socket =
      assign(socket,
        page: page,
        people:
          fetch_people(
            amount: amount,
            paginate: paginate,
            page: page
          )
      )

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "update",
        %{
          "people" => %{
            "amount" => amount_input,
            "render_strategy" => render_strategy,
            "paginate" => paginate_input
          }
        },
        %Phoenix.LiveView.Socket{
          assigns: %{
            page: page
          }
        } = socket
      ) do
    amount = parse_amount(amount_input)

    {:noreply,
     assign(
       socket,
       amount: amount,
       paginate: parse_boolean(paginate_input),
       people:
         fetch_people(
           amount: amount,
           paginate: parse_boolean(paginate_input),
           page: page
         ),
       render_strategy: render_strategy
     )}
  end

  @impl true
  def handle_info(
        {:tick, tick_count},
        %Phoenix.LiveView.Socket{
          assigns: %{
            amount: amount,
            paginate: paginate,
            page: page
          }
        } = socket
      ) do
    {:noreply,
     assign(socket,
       people:
         fetch_people(
           amount: amount,
           paginate: paginate,
           page: page
         ),
       tick: tick_count
     )}
  end

  defp fetch_people(amount: amount, paginate: false, page: _) do
    People.list(limit: amount)
  end

  defp fetch_people(amount: _, paginate: true, page: page) do
    People.list(page: page)
  end

  defp max_amount, do: 30000
  defp min_amount, do: 1

  defp parse_amount(""), do: 1

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

  defp pagination_link(socket, text, page, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page
        ),
      class: class
    )
  end

  defp subscribe_tick_pubsub() do
    Phoenix.PubSub.subscribe(Speedy.PubSub, "tick")
  end
end
