defmodule Speedy.People do
  alias Speedy.Person

  def generate(amount) do
    Stream.map(1..amount, &Person.generate(&1))
  end
end
