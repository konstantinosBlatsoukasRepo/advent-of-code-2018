defmodule DayFour do
  alias DayFour.Shifts

  def guard_that_sleeps_the_most do
    sleeping_ranges = calculate_sleep_ranges_per_guard()

    {most_sleepy_guard, _} =
      calculate_total_sleep_per_guard(sleeping_ranges)
      |> calculate_the_most_sleepy_guard

    {sleepiest_minute, _} =
      Map.get(sleeping_ranges, most_sleepy_guard)
      |> calculate_the_most_sleepy_minute()
      |> most_sleepy_minute()

      IO.inspect(most_sleepy_guard)
      IO.inspect(sleepiest_minute)

    sleepiest_minute * most_sleepy_guard
  end

  def calculate_sleep_ranges_per_guard do
    shifts_events = Shifts.parse_shifts()

    [first_event | rest] = shifts_events

    first_guard = first_event.state
    do_calculate_sleep_ranges_per_guard(Map.new(), rest, first_guard)
  end

  def do_calculate_sleep_ranges_per_guard(events_per_guard, [], _), do: events_per_guard

  def do_calculate_sleep_ranges_per_guard(events_per_guard, [shift_event | shifts_events], guard) do
    case shift_event.state do
      :falls_asleep ->
        events_per_guard =
          add_new_event(
            events_per_guard,
            guard,
            shift_event.minute,
            :falls_asleep,
            shift_event.date
          )

        do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, guard)

      :wakes_up ->
        events_per_guard =
          add_new_event(events_per_guard, guard, shift_event.minute, :wakes_up, shift_event.date)

        do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, guard)

      new_guard_shift ->
        case Enum.member?(events_per_guard, new_guard_shift) do
          true ->
            events_per_guard =
              add_new_event(
                events_per_guard,
                new_guard_shift,
                shift_event.minute,
                :first_shift,
                shift_event.date
              )

            do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, new_guard_shift)

          false ->
            events_per_guard = Map.put_new(events_per_guard, new_guard_shift, [])
            do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, new_guard_shift)
        end
    end
  end

  def add_new_event(events_per_guard, id, minute, event_type, date) do
    case Map.fetch(events_per_guard, id) do
      {:ok, events} ->
        Map.put(events_per_guard, id, [{event_type, minute, date} | events])

      :error ->
        Map.put(events_per_guard, id, [{event_type, minute, date}])
    end
  end

  def guard_total_sleep_time(guards_and_sleeping) do
    case guards_and_sleeping do
      [] ->
        0

      [wake_up_minute | [fall_asleep_minute | rest_shifts]] ->
        {:wakes_up, wake_minute, _} = wake_up_minute

        {:falls_asleep, sleep_minute, _} = fall_asleep_minute

        wake_minute - sleep_minute + guard_total_sleep_time(rest_shifts)
    end
  end

  def calculate_total_sleep_per_guard(sleeping_ranges) do
    Enum.reduce(sleeping_ranges, %{}, fn
      {k, v}, acc -> Map.put(acc, k, guard_total_sleep_time(v))
    end)
  end

  def calculate_the_most_sleepy_guard(total_sleep_per_guard) do
    Enum.reduce(total_sleep_per_guard, {-1, -1}, fn
      {k, v}, {most_sleepy_id, total_sleep} ->
        case v > total_sleep do
          true -> {k, v}
          _ -> {most_sleepy_id, total_sleep}
        end
    end)
  end

  def calculate_the_most_sleepy_minute(ranges_of_most_sleepy) do
    minutes_map =
      Enum.map(0..59, fn x -> x end)
      |> Enum.reduce(%{}, fn k, acc -> Map.put(acc, k, 0) end)

    do_calculate_the_most_sleepy_minute(ranges_of_most_sleepy, minutes_map)
  end

  def do_calculate_the_most_sleepy_minute([], minutes_map), do: minutes_map

  def do_calculate_the_most_sleepy_minute([head | rest], minutes_map) do
    {:wakes_up, upper_bound, _} = head
    upper_bound = upper_bound - 1

    [{:falls_asleep, lower_bound, _} | rest_of_the_rest] = rest

    range = Enum.map(lower_bound..upper_bound, fn x -> x end)

    minutes_map =
      Enum.reduce(range, minutes_map, fn x, acc ->
        {_, fresh_map} =
          Map.get_and_update(acc, x, fn current_value -> {current_value, current_value + 1} end)

        fresh_map
      end)

    do_calculate_the_most_sleepy_minute(rest_of_the_rest, minutes_map)
  end

  def most_sleepy_minute(asleep_minutes_frequency) do
    Enum.reduce(asleep_minutes_frequency, {0, 0}, fn {k, v}, {res_minute, freq} ->
      case v > freq do
        true -> {k, v}
        false -> {res_minute, freq}
      end
    end)
  end

end
