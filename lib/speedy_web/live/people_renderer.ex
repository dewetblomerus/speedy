defmodule SpeedyWeb.PeopleRenderer do
  use Phoenix.Component

  def list_people(%{render_strategy: "default_comprehension"} = assigns) do
    ~H"""
    <h3>Heex Inside Comprehension</h3>
    <%= for person <- @people do %>
      <tr>
        <td><%= person.id %></td>
        <td><%= person.name %></td>
        <td><%= person.age %></td>
        <td><%= person.weapon %></td>
        <td><%= person.status %></td>
      </tr>
    <% end %>
    """
  end

  def list_people(%{render_strategy: "default_with_id"} = assigns) do
    ~H"""
    <h3>Heex Inside Comprehension With ID</h3>
    <%= for person <- @people do %>
      <tr id={"person-#{person.id}"}>
        <td><%= person.id %></td>
        <td><%= person.name %></td>
        <td><%= person.age %></td>
        <td><%= person.weapon %></td>
        <td><%= person.status %></td>
      </tr>
    <% end %>
    """
  end

  def list_people(%{render_strategy: "live_components_number_ids"} = assigns) do
    ~H"""
    <h3>Live Components Number Ids</h3>
    <%= for person <- @people do %>
      <.live_component
        module={SpeedyWeb.PersonComponent}
        id={person.id}
        person={person}
      />
    <% end %>
    """
  end

  def list_people(%{render_strategy: "live_components_string_ids"} = assigns) do
    ~H"""
    <h3>Live Components String Ids</h3>
    <%= for person <- @people do %>
      <.live_component
        module={SpeedyWeb.PersonComponent}
        id={"person-#{person.id}"}
        person={person}
      />
    <% end %>
    """
  end
end
