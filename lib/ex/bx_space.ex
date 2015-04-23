defmodule BX.Space do

  @doc """
  Creates a new space
  """  
  def new(code) do
    multi_list = code |> String.split("\n") |> Enum.map &String.codepoints/1 # &(String.split &1, "")
    multi_list_to_space(multi_list, %{ size_x: 0, size_y: 0, space: %{} }).space
  end

  @doc """
  Maps a list to a map of points
  """
  def list_to_space(list, acc) do
    Enum.reduce(list, acc, 
      fn (head, %{ size_x: size_x, size_y: size_y, space: points }) ->
        %{
          size_x: size_x + 1,
          size_y: size_y,
          space: Map.put(points, %{x: size_x, y: size_y}, head)
        }
      end)
  end

  @doc """
  Converts a list of lists to a space
  """
  def multi_list_to_space(multi_list, acc) do
    Enum.reduce(multi_list, acc, 
      fn (line, %{ size_x: size_x, size_y: size_y, space: points }) ->
        %{
          size_x: size_x, # Enum.max([size_x, Enum.count(line)]),
          size_y: size_y + 1,
          space: list_to_space(line, %{size_x: size_x, size_y: size_y, space: points }) |> Map.get :space
        }
      end)
  end

  @doc """
  Returns the size of the space
  """
  def size(space) do
    %{ x: x, y: y} = Map.keys(space) |> 
      Enum.reduce fn (%{x: a1, y: b1}, %{x: a2, y: b2}) -> 
        %{ x: if a1 > a2 do a1 else a2 end, y: if b1 > b2 do b1 else b2 end } 
      end
    %{ size_x: x+1, size_y: y+1 }
  end
end
