defmodule SpeedyWeb.PeopleRenderer do
  use Phoenix.Component

  def list_people(%{render_strategy: "Heex Inside Comprehension"} = assigns) do
    ~H"""
    <a
      href="https://github.com/dewetblomerus/speedy/blob/main/lib/speedy_web/live/people_renderer.ex#L10-L20"
      target="_blank"
    >
      <h3>Heex Inside Comprehension</h3>
    </a>
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

  def list_people(
        %{render_strategy: "Heex Inside Comprehension With ID"} = assigns
      ) do
    ~H"""
    <a
      href="https://github.com/dewetblomerus/speedy/blob/main/lib/speedy_web/live/people_renderer.ex#L30-L40"
      target="_blank"
    >
      <h3>Heex Inside Comprehension With ID</h3>
    </a>
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

  def list_people(%{render_strategy: "Live Components Number IDs"} = assigns) do
    ~H"""
    <a
      href="https://github.com/dewetblomerus/speedy/blob/main/lib/speedy_web/live/people_renderer.ex#L50-L58"
      target="_blank"
    >
      <h3>Live Components Number Ids</h3>
    </a>
    <%= for person <- @people do %>
      <.live_component
        module={SpeedyWeb.PersonComponent}
        id={person.id}
        person={person}
      />
    <% end %>
    """
  end

  def list_people(%{render_strategy: "Live Components String IDs"} = assigns) do
    ~H"""
    <a
      href="https://github.com/dewetblomerus/speedy/blob/main/lib/speedy_web/live/people_renderer.ex#L68-L76"
      target="_blank"
    >
      <h3>Live Components String Ids</h3>
    </a>
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
