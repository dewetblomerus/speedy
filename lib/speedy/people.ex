defmodule Speedy.People do
  require Logger
  alias Speedy.Person

  def generate(amount) do
    Enum.map(1..amount, &Person.generate(&1))
  end

  def update(people, every) do
    offset = Enum.random(0..every)
    update_loop(people, offset, every)
  end

  defp update_loop([%{id: id} = person | people], offset, every)
       when rem(id + offset, every) == 0 do
    new_person = Person.generate(person.id)
    [new_person | update_loop(people, offset, every)]
  end

  defp update_loop([person | people], offset, every) do
    [person | update_loop(people, offset, every)]
  end

  defp update_loop([], _, _) do
    []
  end
end
