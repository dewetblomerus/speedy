defmodule Speedy.Person do
  @enforce_keys [:id]
  defstruct ~w[name age id weapon status]a
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

  def generate(id) do
    name = Enum.random(@names)
    age = Enum.random(17..70)
    weapon = Enum.random(@weapons)
    status = Enum.random(@statuses)

    %Person{
      id: id,
      name: name,
      age: age,
      weapon: weapon,
      status: status
    }
  end
end
