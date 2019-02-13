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

  def find_the_correct_words do
    [first_id | rest_ids] = AdventOfCode2018.read_input(@day_two_input_path)

    do_find_the_correct_words(first_id, rest_ids)
  end

  def do_find_the_correct_words(_, []), do: :not_the_one

  def do_find_the_correct_words(first_id, rest_ids) do

    case search_the_boxes(first_id, rest_ids) do
      :not_found ->
        [next_id | rest]= rest_ids
        do_find_the_correct_words(next_id, rest)
      found -> found
    end

  end

  def search_the_boxes(_, []), do: :not_found

  def search_the_boxes(word, [other_word | rest]) do
    case total_diff_chars(word, other_word) do
      :not_correct -> search_the_boxes(word, rest)
      :correct -> {:found, word, other_word}
    end
  end

  def total_diff_chars(first_word, second_word) do
    first_word_list = String.to_charlist(first_word)
    second_word_list = String.to_charlist(second_word)

    do_total_diff_chars(first_word_list, second_word_list, 0)
  end

  defp do_total_diff_chars(_, _, count) when count > 1, do: :not_correct

  defp do_total_diff_chars([], [], 1), do: :correct

  defp do_total_diff_chars([first_char | first_rest], [second_char | second_rest], count) do
    case first_char == second_char do
      true -> do_total_diff_chars(first_rest, second_rest, count)
      false -> do_total_diff_chars(first_rest, second_rest, count + 1)
    end
  end
end
