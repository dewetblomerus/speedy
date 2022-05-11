defmodule Speedy.People do
  require Logger
  alias Speedy.Person

  @divisor 10

  def generate(amount) do
    Enum.map(1..amount, &Person.generate(&1))
  end

  def update(people, percentage) do
    offset = Enum.random(1..@divisor)
    threshold = div(percentage, @divisor)
    update_loop(people, offset, threshold)
  end

  defp update_loop([%{id: id} = person | people], offset, threshold)
       when rem(id + offset, @divisor) < threshold do
    new_person = Person.generate(person.id)
    [new_person | update_loop(people, offset, threshold)]
  end

  defp update_loop([person | people], offset, threshold) do
    [person | update_loop(people, offset, threshold)]
  end

  defp update_loop([], _, _) do
    []
  end
end
