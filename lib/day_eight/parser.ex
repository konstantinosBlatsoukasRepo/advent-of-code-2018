defmodule DayEight.Parser do
  # @day_eight_input_path "./lib/day_eight/day_eight_input.txt"
  @day_eight_input_path "./lib/day_eight/test_eight.txt"

  def parse() do
    {:ok, input} = File.read(@day_eight_input_path)

    String.split(input)
    |> Enum.map(&String.to_integer/1)
  end

end
