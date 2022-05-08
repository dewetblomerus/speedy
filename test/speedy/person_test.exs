defmodule Speedy.PersonTest do
  use ExUnit.Case, async: true
  alias Speedy.Person

  describe "generate" do
    test "generates a person" do
      assert %Person{id: 5, name: name, age: age} = Person.generate(5)
      assert Enum.member?(6..900, age)
      assert is_binary(name)
    end
  end
end
