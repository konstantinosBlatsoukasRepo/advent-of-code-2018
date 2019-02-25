defmodule DaySix.PartOne.Solution do
  alias DaySix.Point

  def part_one() do
    parsed_points =
      DaySix.Parser.parse_points()
      |> MapSet.new()

    {max_column, max_row} = find_max_row_column(parsed_points)

    points_with_min_distances =
      generate_all_points({max_column, max_row}, parsed_points)
      |> Enum.map(fn point ->
        %Point{column: column, row: row} = point
        %{{column, row} => calculate_closest_point_from(point, parsed_points)}
      end)

    infinite_points =
      extract_infinite_points(points_with_min_distances, {max_column, max_row})
      |> MapSet.new()

    max_area =
    filter_points_with_infinite_distance(points_with_min_distances, infinite_points)
    |> count_area_per_point()
    |> Map.values()
    |> Enum.max

    max_area + 1
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

  def generate_all_points(max_row_column, parsed_points) do
    {max_column, max_row} = max_row_column

    for column <- 0..max_column,
        row <- 0..max_row,
        not MapSet.member?(parsed_points, %Point{column: column, row: row}) do
      %Point{column: column, row: row}
    end
  end

  def calculate_closest_point_from(point, parsed_points) do
    Enum.reduce(
      parsed_points,
      {%Point{}, 1_000_000_000_000_000_000},
      fn parsed_point, {min_point, min_distance} ->
        current_distance = manhattan_distance(point, parsed_point)

        cond do
          current_distance == min_distance -> {".", min_distance}
          current_distance < min_distance -> {parsed_point, current_distance}
          true -> {min_point, min_distance}
        end
      end
    )
  end

  def manhattan_distance(point, another_point) do
    %Point{column: column, row: row} = point
    %Point{column: another_column, row: another_row} = another_point

    abs(column - another_column) + abs(row - another_row)
  end

  def extract_infinite_points(points_with_min_distances, {max_column, max_row}) do
    Enum.reduce(points_with_min_distances, MapSet.new(), fn map, acc ->
      [{column, row}] = Map.keys(map)
      [{point, _}] = Map.values(map)

      case column == 0 or row == 0 or column == max_column or row == max_row do
        true -> MapSet.put(acc, point)
        false -> acc
      end
    end)
  end

  def count_area_per_point(points) do
    Enum.reduce(points, Map.new(), fn map, acc ->
      [{point, _}] = Map.values(map)

      case Map.get(acc, point) do
        nil -> Map.put(acc, point, 1)
        count -> Map.put(acc, point, count + 1)
      end
    end)
  end

  def filter_points_with_infinite_distance(points_with_min_distances, infinite_points) do
    Enum.filter(points_with_min_distances, fn map ->
      [{point, _}] = Map.values(map)
      not MapSet.member?(infinite_points, point)
    end)
  end
end
