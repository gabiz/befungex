defmodule BX.CursorTest do
  use ExUnit.Case
  alias BX.Cursor

  setup do
    {:ok, []}
  end

  test "creates cursor" do
    assert Cursor.new == %{ x: 0, y: 0, dx: 1, dy: 0, size_x: 10, size_y: 10 }
  end

  test "advances cursor" do
    assert Cursor.new |> Cursor.advance == %{ x: 1, y: 0, dx: 1, dy: 0, size_x: 10, size_y: 10 }
  end

  test "changes direction" do
    assert Cursor.new |> Cursor.change_direction({ -1, 0 }) == %{ x: 0, y: 0, dx: -1, dy: 0, size_x: 10, size_y: 10 }
  end

  test "changes direction randomly" do
    first = Cursor.new
    second = first |> Cursor.random_direction
    third = second |> Cursor.random_direction
    fourth = third |> Cursor.random_direction
    assert !(first == second) and !(first == third) and !(first == fourth)
  end
end