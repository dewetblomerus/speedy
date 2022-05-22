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
       tick: nil
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
    paginate = parse_boolean(params["paginate"] || "false")
    page = String.to_integer(params["page"] || "1")

    socket =
      assign(socket,
        page: page,
        paginate: paginate,
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
    paginate = parse_boolean(paginate_input)

    people =
      fetch_people(
        amount: amount,
        paginate: parse_boolean(paginate_input),
        page: page
      )

    updated_socket =
      assign(
        socket,
        amount: amount,
        paginate: paginate,
        people: people,
        render_strategy: render_strategy
      )

    {:noreply,
     push_patch(
       updated_socket,
       to: Routes.live_path(updated_socket, __MODULE__, paginate: paginate)
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
          page: page,
          paginate: true
        ),
      class: class
    )
  end

  defp subscribe_tick_pubsub() do
    Phoenix.PubSub.subscribe(Speedy.PubSub, "tick")
  end

  defp paginate_buttons(%{paginate: false}), do: nil

  defp paginate_buttons(assigns) do
    ~H"""
    <div class="footer">
      <div class="pagination">
        <%= if @page > 1 do %>
          <%= pagination_link(
            @socket,
            "First",
            1,
            "first"
          ) %>
          <%= pagination_link(
            @socket,
            "Previous",
            @page - 1,
            "previous"
          ) %>
        <% end %>
        <%= for i <- (@page - 1)..(@page + 1), i > 0 && i <= pages() do %>
          <%= pagination_link(
            @socket,
            i,
            i,
            if(i == @page, do: "active")
          ) %>
        <% end %>
        <%= if @page < pages() do %>
          <%= pagination_link(
            @socket,
            "Next",
            @page + 1,
            "next"
          ) %>
          <%= pagination_link(
            @socket,
            "Last",
            pages(),
            "last"
          ) %>
        <% end %>
      </div>
    </div>
    """
  end

  defp pages() do
    Application.fetch_env!(:speedy, :people_pages)
  end
end
