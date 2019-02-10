defmodule DayOne do
  import File, only: [read: 1]

  @day_one_input_path "./lib/day_one/day_one_input.txt"

  def calibrate_the_frequency() do
    case read(@day_one_input_path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()

      {:error, reason} ->
        reason
    end
  end
end
