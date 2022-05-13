defmodule SpeedyWeb.PersonComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use SpeedyWeb, :live_component

  def render(assigns) do
    ~H"""
      <tr>
        <td><%= @person.id %></td>
        <td><%= @person.name %></td>
        <td><%= @person.age %></td>
        <td><%= @person.weapon %></td>
        <td><%= @person.status %></td>
      </tr>
    """
  end
end
