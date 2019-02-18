defmodule DayFour.Shifts do
  alias DayFour.Shift

  @day_four_input_path "./lib/day_four/day_four_input.txt"

  def parse_shifts do
    AdventOfCode2018.read_input(@day_four_input_path)
    |> Enum.map(&parse_shift/1)
    |> Enum.sort_by(&{&1.date, &1.hour, &1.minute})
  end

  def parse_shift(shift) do
    [_, date_time, state] = String.split(shift, ["[", "]"])
    [date, time] = String.split(date_time)
    {:ok, date} = Date.from_iso8601(date)
    [hour, minute] = String.split(time, ":")

    %Shift{
      date: date,
      hour: String.to_integer(hour),
      minute: String.to_integer(minute),
      state: state
    }
  end
end
