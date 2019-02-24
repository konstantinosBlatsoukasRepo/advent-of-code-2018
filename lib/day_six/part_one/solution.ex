defmodule DaySix.PartOne.Solution do
  alias DaySix.Point

  def part_one() do
    points = DaySix.Parser.parse_points()

    {max_column, max_row} = find_max_row_column(points)

    max_point = %Point{column: max_column, row: max_row}
  end

  def find_max_row_column(points) do
    Enum.reduce(points, {-1, -1}, fn
      point, max_tuple ->
        max_column_row_tuple(point, max_tuple)
    end)
  end

  def max_column_row_tuple(current_point, max_tuple) do
    %Point{column: column, row: row} = current_point
    {max_column, max_row} = max_tuple

    cond do
      column > max_column and row > max_row -> {column, row}
      column > max_column -> {column, max_row}
      row > max_row -> {max_column, row}
      true -> {max_column, max_row}
    end
  end

  def manhattan_distance(point, another_point) do
    %Point{column: column, row: row} = point
    %Point{column: another_column, row: another_row} = another_point

    abs(column - another_column) + abs(row - another_row)
  end
end
