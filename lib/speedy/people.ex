defmodule Speedy.People do
  alias Speedy.Person

  def generate(amount) do
    Enum.map(1..amount, &Person.generate(&1))
  end
end
