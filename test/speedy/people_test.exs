defmodule Speedy.PeopleTest do
  require IEx
  use ExUnit.Case, async: true
  alias Speedy.{Person, People}

  describe "generate/1" do
    test "generates a list of people" do
      assert [%Person{}] = People.generate(1)

      amount = Enum.random(1..1000)

      assert People.generate(amount)
             |> length() == amount
    end
  end

  describe "update/1" do
    test "updates roughly a given percentage of the people" do
      people = People.generate(3)

      refute people == People.update(people, 50)
      both = people ++ People.update(people, 0)
      assert Enum.uniq(both) |> length() == 1
    end
  end
end
