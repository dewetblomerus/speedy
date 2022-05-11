defmodule Speedy.Person do
  @constant_keys [:id]
  @variable_keys ~w[
    age
    midi_chlorian_count
    name
    status
    weapon
  ]a

  @all_keys @variable_keys ++ @constant_keys
  @enforce_keys @all_keys
  defstruct @all_keys
  alias __MODULE__

  @names [
    "Anakin Skywalker",
    "BB8",
    "Boba Fett",
    "C-3PO",
    "Chewbacca",
    "Darth Maul",
    "Darth Vader",
    "Finn",
    "Han Solo",
    "Lando Calrissian",
    "Leia Organa",
    "Luke Skywalker",
    "Obi-Wan Kenobi",
    "Padmé Amidala",
    "Palpatine",
    "Poe Dameron",
    "R2-D2",
    "Rey",
    "Yoda"
  ]
  @weapons ~w[🔫 🏹 𐃉]
  @statuses ~w[😁 😀 😆 🤣 🙂 🥳 😡 🤯 😱 😰 🥶 🤢 👍 👎 🤘 🙏🏼 ]
  @ages 17..70
  @midi_chlorians 7000..27000
  @all_possible_values %{
    name: @names,
    weapon: @weapons,
    status: @statuses,
    age: @ages,
    midi_chlorian_count: @midi_chlorians
  }

  def generate(id) do
    name = Enum.random(@names)
    age = Enum.random(@ages)
    weapon = Enum.random(@weapons)
    status = Enum.random(@statuses)
    midi_chlorian_count = Enum.random(@all_possible_values.midi_chlorian_count)

    %Person{
      id: id,
      name: name,
      age: age,
      weapon: weapon,
      status: status,
      midi_chlorian_count: midi_chlorian_count
    }
  end

  def update(person) do
    key_to_update = Enum.random(@variable_keys)
    old_value = Map.get(person, key_to_update)

    new_value =
      @all_possible_values
      |> Map.get(key_to_update)
      |> Enum.random()

    person
    |> Map.put(key_to_update, new_value)
  end
end
