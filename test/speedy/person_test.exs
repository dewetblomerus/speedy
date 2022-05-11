defmodule Speedy.PersonTest do
  use ExUnit.Case, async: true
  alias Speedy.Person

  describe "generate/1" do
    test "generates a person" do
      assert %Person{id: 5, name: name, age: age} = Person.generate(5)
      assert Enum.member?(6..900, age)
      assert is_binary(name)
    end
  end

  describe "update/0" do
    @tag :skip
    test "makes a minor update to a person" do
      person = Person.generate(42)

      for n <- 1..100 do
        refute person == Person.update(person)
      end
    end
  end
end
