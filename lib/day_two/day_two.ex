defmodule DayTwo do
  @day_two_input_path "./lib/day_two/day_two_input.txt"

  def calculate_checksum do
    box_ids = AdventOfCode2018.read_input(@day_two_input_path)

    {total_twos, total_threes} =
      Enum.map(box_ids, &calculate_chars_frequency/1)
      |> Enum.map(&count_twos_and_threes/1)
      |> calculate_total_twos_and_threes()

    total_twos * total_threes
  end

  def calculate_chars_frequency(word) do
    chars = String.to_charlist(word)

    Enum.reduce(chars, %{}, fn char, acc ->
      case Map.get(acc, char) do
        nil ->
          Map.put(acc, char, 1)

        _ ->
          old_value = Map.get(acc, char)
          Map.put(acc, char, old_value + 1)
      end
    end)
  end

  def count_twos_and_threes(chars_frequencies) do
    frequencies = Map.values(chars_frequencies)
    do_count_twos_and_threes(frequencies, 0, 0)
  end

  defp do_count_twos_and_threes(_, total_twos, total_threes)
       when total_twos >= 1 and total_threes >= 1,
       do: {total_twos, total_threes}

  defp do_count_twos_and_threes([], total_twos, 0) when total_twos >= 1, do: {1, 0}
  defp do_count_twos_and_threes([], 0, total_threes) when total_threes >= 1, do: {0, 1}

  defp do_count_twos_and_threes([], total_twos, total_threes), do: {total_twos, total_threes}

  defp do_count_twos_and_threes([frequency | rest], total_twos, total_threes) do
    case frequency do
      2 -> do_count_twos_and_threes(rest, total_twos + 1, total_threes)
      3 -> do_count_twos_and_threes(rest, total_twos, total_threes + 1)
      _ -> do_count_twos_and_threes(rest, total_twos, total_threes)
    end
  end

  defp calculate_total_twos_and_threes(total_twos_and_threes) do
    Enum.reduce(total_twos_and_threes, {0, 0}, fn {twos, threes}, acc ->
      {twos_counter, threes_counter} = acc

      case {twos, threes} do
        {0, 0} -> {twos_counter, threes_counter}
        {1, 0} -> {twos_counter + 1, threes_counter}
        {0, 1} -> {twos_counter, threes_counter + 1}
        {1, 1} -> {twos_counter + 1, threes_counter + 1}
      end
    end)
  end
end
