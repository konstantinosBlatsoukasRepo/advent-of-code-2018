defmodule DaySix.PartTwo.Solution do
  alias DaySix.Parser
  alias DaySix.PartOne.Solution, as: PartOne
  alias DaySix.Point

  @max_region_distance 10000

  def part_two() do
    parsed_points =
      Parser.parse_points()
      |> MapSet.new()

    all_points =
      PartOne.find_max_row_column(parsed_points)
      |> PartOne.generate_all_points(parsed_points)

    points_within_region = calculate_all_distances_within_region(all_points, parsed_points)

    parsed_points_within_region = Enum.filter(parsed_points, &(point_within_region?(&1, points_within_region)))

    MapSet.size(points_within_region) + length(parsed_points_within_region)
  end

  def calculate_all_distances_within_region(all_points, parsed_points) do
    Stream.map(all_points, &calculate_total_distance(&1, parsed_points))
    |> Stream.filter(&(&1 != :out_of_region))
    |> MapSet.new()
  end

  def calculate_total_distance(point, parsed_points) do
    parsed_points = MapSet.to_list(parsed_points)
    do_calculate_total_distance(point, parsed_points, 0)
  end

  def do_calculate_total_distance(point, [], total_distance) do
    case total_distance >= @max_region_distance do
      true -> :out_of_region
      false -> point
    end
  end

  def do_calculate_total_distance(point, [other_point | rest], total_distance) do
    manhattan_distance = PartOne.manhattan_distance(point, other_point)

    cond do
      manhattan_distance < @max_region_distance ->
        total_distance = total_distance + manhattan_distance
        do_calculate_total_distance(point, rest, total_distance)

      true ->
        :out_of_region
    end
  end

  def point_within_region?(point, points_within_region) do
    %Point{column: column, row: row} = point

    MapSet.member?(points_within_region, %Point{column: column + 1, row: row}) and
      MapSet.member?(points_within_region, %Point{column: column - 1, row: row}) and
      MapSet.member?(points_within_region, %Point{column: column, row: row + 1}) and
      MapSet.member?(points_within_region, %Point{column: column, row: row - 1})
  end
end
