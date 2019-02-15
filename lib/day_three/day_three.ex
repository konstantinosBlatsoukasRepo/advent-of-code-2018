defmodule DayThree do
  @day_three_input_path "./lib/day_three/day_three_input.txt"

  # @day_three_input_path "./lib/day_three/test_input.txt"

  def parse_claims do
    AdventOfCode2018.read_input(@day_three_input_path)
    |> Enum.map(&parse_claim/1)
  end

  def parse_claim(claim) do
    [_, coordinates] = String.split(claim, "@")
    [dist_from_edges, dimensions] = String.split(coordinates, ":")

    {dist_from_left, dist_from_top} = parse_distances(dist_from_edges)

    {width, height} = parse_dimensions(dimensions)

    left_upper_corner = {dist_from_left, dist_from_top}
    bottom_right_corner = {dist_from_left + (width - 1), dist_from_top + (height - 1)}

    {left_upper_corner, bottom_right_corner}
  end

  defp parse_distances(dist_from_edges) do
    [dist_left, dist_top] =
      String.split(dist_from_edges, ",")
      |> Enum.map(&String.trim/1)

    {String.to_integer(dist_left), String.to_integer(dist_top)}
  end

  defp parse_dimensions(dimensions) do
    [width, height] =
      String.split(dimensions, "x")
      |> Enum.map(&String.trim/1)

    {String.to_integer(width), String.to_integer(height)}
  end

  def calculate_common_inches do
    [first_claim | rest] = parse_claims()

    common_inches = do_calculate_common_inches(first_claim, rest, MapSet.new(), rest)
    MapSet.size(common_inches)
  end

  defp do_calculate_common_inches(_, _, map_set, []), do: map_set

  defp do_calculate_common_inches(_, [], map_set, current_claims) do
    [next_claim | rest] = current_claims
    do_calculate_common_inches(next_claim, rest, map_set, rest)
  end

  defp do_calculate_common_inches(current_claim, rest, map_set, current_claims) do
    [next_to_current | rest_of_the_rest] = rest

    current_claim_points = generate_claim_points(current_claim)
    next_to_current_claim_points = generate_claim_points(next_to_current)

    common_inches = extract_common_inches(current_claim_points, next_to_current_claim_points, map_set)

    do_calculate_common_inches(
      current_claim,
      rest_of_the_rest,
      common_inches,
      current_claims
    )
  end

  def claims_intersect?(claim_one, claim_two) do
    common_x?(claim_one, claim_two) and common_y?(claim_one, claim_two)
  end

  defp common_x?(claim_one, claim_two) do
    {{min_x_one, _}, {max_x_one, _}} = claim_one
    {{min_x_two, _}, {max_x_two, _}} = claim_two

    first_condition = min_x_one > min_x_two and min_x_one < max_x_two
    second_condition = max_x_one > min_x_two and max_x_one < max_x_two
    first_condition or second_condition
  end

  defp common_y?(claim_one, claim_two) do
    {{_, min_y_one}, {_, max_y_one}} = claim_one
    {{_, min_y_two}, {_, max_y_two}} = claim_two

    first_condition = min_y_one > min_y_two and min_y_one < max_y_two
    second_condition = max_y_one > min_y_two and max_y_one < max_y_two
    first_condition or second_condition
  end

  def generate_claim_points(claim) do
    {{mix_x, min_y}, {max_x, max_y}} = claim
    for x <- mix_x..max_x, y <- min_y..max_y, do: {x, y}
  end

  def extract_common_inches(claim_one_points, claim_two_points, map_set) do
    do_count_common_inches(claim_one_points, claim_two_points, map_set)
  end

  defp do_count_common_inches([], _, map_set), do: map_set

  defp do_count_common_inches([point | rest], claim_two_points, map_set) do
    case Enum.member?(claim_two_points, point) do
      true -> do_count_common_inches(rest, claim_two_points, MapSet.put(map_set, point))
      false -> do_count_common_inches(rest, claim_two_points, map_set)
    end
  end
end
