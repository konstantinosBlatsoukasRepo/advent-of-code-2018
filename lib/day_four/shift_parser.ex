defmodule DayFour.Shifts do
  alias DayFour.Shift

  require Logger

  @day_four_input_path "./lib/day_four/day_four_input.txt"
  @regex Regex.recompile(~r"\d+")

  def parse_shifts do
    AdventOfCode2018.read_input(@day_four_input_path)
    |> Enum.map(&parse_shift/1)
    |> Enum.sort_by(&{&1.date, &1.hour, &1.minute})
    |> Enum.each(&Logger.debug(inspect(&1)))
  end

  def parse_shift(shift) do
    [_, date_time, state] = String.split(shift, ["[", "]"])
    [date, time] = String.split(date_time)
    {:ok, date} = Date.from_iso8601(date)
    [hour, minute] = String.split(time, ":")

    case state do
      " wakes up" ->
        state = :wakes_up
        %Shift{
          date: date,
          hour: String.to_integer(hour),
          minute: String.to_integer(minute),
          state: state
        }

      " falls asleep" ->
        state = :falls_asleep
        %Shift{
          date: date,
          hour: String.to_integer(hour),
          minute: String.to_integer(minute),
          state: state
        }

      guard_id ->
        {:ok, regex} = @regex
        [id | _] = Regex.run(regex, guard_id)
        state = String.to_integer(id)
        %Shift{
          date: date,
          hour: String.to_integer(hour),
          minute: String.to_integer(minute),
          state: state
        }
    end


  end
end
