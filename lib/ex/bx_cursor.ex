defmodule BX.Cursor do
  @doc """
  Create a cursor
  """
  def new( size \\ %{ size_x: 10, size_y: 10 }) do
    %{ x: 0, y: 0, dx: 1, dy: 0, size_x: size.size_x, size_y: size.size_y }
  end

  @doc """
  Extracts the position of the cursor
  """
  def position(cursor) do
    %{x: cursor.x, y: cursor.y}
  end

  @doc """
  Move to the nBXt position based on the current direction
  """
  def advance(%{ x: x, y: y, dx: dx, dy: dy, size_x: size_x, size_y: size_y} = cursor) do
    %{ cursor | x: rem(x+dx+size_x, size_x), y: rem(y+dy+size_y, size_y) }
  end

  @doc """
  Change direction
  """
  def change_direction(cursor, {1, 0}), do:  %{ cursor | dx: 1, dy: 0 }
  def change_direction(cursor, ">"), do:  %{ cursor | dx: 1, dy: 0 }
  def change_direction(cursor, {-1, 0}), do:  %{ cursor | dx: -1, dy: 0 }
  def change_direction(cursor, "<"), do:  %{ cursor | dx: -1, dy: 0 }
  def change_direction(cursor, {0, 1}), do:  %{ cursor | dx: 0, dy: 1 }
  def change_direction(cursor, "v"), do:  %{ cursor | dx: 0, dy: 1 }
  def change_direction(cursor, {0, -1}), do:  %{ cursor | dx: 0, dy: -1 }
  def change_direction(cursor, "^"), do:  %{ cursor | dx: 0, dy: -1 }
  def change_direction(_cursor, dir), do:  raise "invalid direction #{inspect dir}"

  @doc """
  Changes to a random direction
  """
  def random_direction(cursor) do
    change_direction cursor, (case trunc(4 * :random.uniform) do
      0 -> {1, 0}
      1 -> {-1, 0}
      2 -> {0, 1}
      3 -> {0, -1}
    end)
  end

end
