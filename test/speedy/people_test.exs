defmodule Speedy.PeopleTest do
  require IEx
  use ExUnit.Case, async: true
  alias Speedy.{Person, People}

  describe "generate/1" do
    test "generates a stream of people" do
      assert [%Person{}] = People.generate(1) |> Enum.map(& &1)

      amount = Enum.random(1..1000)

      assert People.generate(amount)
             |> Enum.map(& &1)
             |> length() == amount
    end
  end
end
