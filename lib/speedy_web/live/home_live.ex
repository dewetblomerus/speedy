defmodule SpeedyWeb.HomeLive do
  use SpeedyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello!!!</h1>
    """
  end
end
