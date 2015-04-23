defmodule BX.SpaceTest do
  use ExUnit.Case
  alias BX.Space

  test "list to space" do
    res = %{ size_x: 5, size_y: 1, space: %{
          %{x: 1, y: 1} => "a",
          %{x: 2, y: 1} => "b",
          %{x: 3, y: 1} => "c",
          %{x: 4, y: 1} => ""
        }
    }
    assert res == String.split("abc", "") 
        |> Space.list_to_space( %{ size_x: 1, size_y: 1, space: %{} })
  end

  test "multi list to space" do
    multi_list = "abc\ndef" |> String.split("\n") |> Enum.map &(String.split &1, "")
    space = Space.multi_list_to_space(multi_list, %{ size_x: 0, size_y: 0, space: %{} })
    assert space.space[%{x: 1, y: 1}] == "e"
  end

  test "creates a space" do
    assert Space.new("abc\ndef")[%{x: 2, y: 1}] == "f"
  end

  test "creates a multiline space" do
    code = """
>25*"!dlrow ,olleH":v
                 v:,_@
                 >  ^
"""
    assert %{size_x: 22, size_y: 3} == (Space.new(code) |> Space.size)
  end

end