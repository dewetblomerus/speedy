defmodule SpeedyWeb.OverviewLive do
  require Logger
  use SpeedyWeb, :live_view
  alias SpeedyWeb.Presence
  alias SpeedyWeb.PresenceState

  @impl true
  def mount(_params, _session, socket) do
    Logger.debug("Mounting #{__MODULE__} 🐴")

    :ok = Phoenix.PubSub.subscribe(Speedy.PubSub, "user-state")
    presence_list = Presence.list("user-state")

    {:ok, assign(socket, presence_list: presence_list)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>Current Users</h1>

    <table>
      <tr>
        <th>Amount</th>
        <th>Page</th>
        <th>Paginate</th>
        <th>Render Strategy</th>
      </tr>
      <%= for user <- list_users(@presence_list) do %>
        <tr>
          <td><%= display_amount(user.amount, user.paginate) %></td>
          <td><%= user.page %></td>
          <td><%= user.paginate %></td>
          <td><%= user.render_strategy %></td>
        </tr>
      <% end %>
    </table>
    """
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{event: "presence_diff", payload: payload},
        socket
      ) do
    new_presence_list =
      PresenceState.sync_diff(socket.assigns.presence_list, payload)

    {:noreply, assign(socket, presence_list: new_presence_list)}
  end

  def list_users(presence_list) do
    presence_list
    |> Enum.map(fn {key, value} -> Map.put(extract_user(value), :id, key) end)
  end

  defp extract_user(%{
         metas: [
           %{} = user | _
         ]
       }) do
    user |> Map.drop([:phx_ref, :phx_ref_prev])
  end

  defp display_amount(_, true) do
    15
  end

  defp display_amount(amount, _) do
    amount
  end
end
