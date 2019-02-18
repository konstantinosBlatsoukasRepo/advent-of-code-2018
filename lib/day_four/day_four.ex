defmodule DayFour do
  alias DayFour.Shifts

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
        events_per_guard = add_new_event(events_per_guard, guard, shift_event.minute)
        do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, guard)

      :wakes_up ->
        events_per_guard = add_new_event(events_per_guard, guard, shift_event.minute)
        do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, guard)

      new_guard_shift ->
        case Enum.member?(events_per_guard, new_guard_shift) do
          true ->
            events_per_guard = add_new_event(events_per_guard, new_guard_shift, shift_event.minute)
            do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, new_guard_shift)
          false ->
            events_per_guard = Map.put_new(events_per_guard, new_guard_shift, [])
            do_calculate_sleep_ranges_per_guard(events_per_guard, shifts_events, guard)
        end
    end
  end

  def add_new_event(events_per_guard, id, minute) do
    events = Map.fetch(events_per_guard, id)
    Map.put(events_per_guard, id, [minute | events])
  end
end
