defmodule ClaimsParser do
  # @day_three_input_path "./lib/day_three/day_three_input.txt"
  @day_three_input_path "./lib/day_three/test_input.txt"

  def parse_claims do
    AdventOfCode2018.read_input(@day_three_input_path)
    |> Enum.map(&parse_claim/1)
  end

  def parse_claims_with_id do
    AdventOfCode2018.read_input(@day_three_input_path)
    |> Enum.map(&parse_claim(&1, :id))
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

  def parse_claim(claim, :id) do
    [id, coordinates] = String.split(claim, "@")
    [dist_from_edges, dimensions] = String.split(coordinates, ":")

    {dist_from_left, dist_from_top} = parse_distances(dist_from_edges)

    {width, height} = parse_dimensions(dimensions)

    left_upper_corner = {dist_from_left, dist_from_top}
    bottom_right_corner = {dist_from_left + (width - 1), dist_from_top + (height - 1)}

    {id, left_upper_corner, bottom_right_corner}
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
end
