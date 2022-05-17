defmodule Speedy.People do
  require Logger
  alias Speedy.Person

  def list(limit: limit) do
    [all: people] = :ets.lookup(:people, :all)
    Enum.take(people, limit)
  end

  def list_from_pages(limit: limit) do
    Enum.reduce_while(1..1_000_000, [], fn page, people ->
      case Speedy.People.list(page: page) do
        [] ->
          {:halt, people}

        _ when length(people) > limit ->
          {:halt, Enum.take(people, limit)}

        page_of_people ->
          {:cont, people ++ page_of_people}
      end
    end)
  end

  def list(page: page) do
    case :ets.lookup(:people, page) do
      [] -> []
      [{_, people}] -> people
    end
  end

  def generate(amount) do
    Enum.map(1..amount, &Person.generate(&1))
  end

  def generate(amount, starting_id) do
    Enum.map(starting_id..(starting_id + amount - 1), &Person.generate(&1))
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
