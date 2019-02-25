defmodule DaySix.Parser do
  @day_six_input_path "./lib/day_six/day_six_input.txt"
  # @day_six_input_path "./lib/day_six/test_six.txt"
  alias DaySix.Point

  def parse_points() do
    {:ok, input} = File.read(@day_six_input_path)

    String.split(input, "\n")
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(&parse_point(&1))
    |> Enum.to_list()
  end

  defp parse_point([column, row]) do
    column = String.to_integer(column)

    row =
      String.trim(row)
      |> String.to_integer()

    %Point{column: column, row: row}
  end
end
