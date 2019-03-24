defmodule DayTen.Parser do
  @day_ten_input_path "./lib/day_ten/day_ten_input.txt"
  # @day_ten_input_path "./lib/day_ten/test_ten.txt"

  def parse() do
    {:ok, input} = File.read(@day_ten_input_path)

    String.split(input, "\n")
    |> Stream.map(&keep_numbers/1)
    |> Stream.map(&transform_to_pairs/1)
    |> Enum.to_list()
  end

  defp keep_numbers(input_line) do
    String.split(input_line, ["position", "=", "<", ">", ",", "velocity", " "], trim: true)
  end

  defp transform_to_pairs(numbers) do
    [right_left, up_down, x_velocity, y_velocity] = numbers
    position = {String.to_integer(right_left), String.to_integer(up_down)}
    velocity = {String.to_integer(x_velocity), String.to_integer(y_velocity)}
    [position: position, velocity: velocity]
  end
end
