defmodule DayFive do
  @day_five_input_path "./lib/day_five/day_five_input.txt"
  # @day_five_input_path "./lib/day_five/test_five.txt"
  @lower_case_chars Enum.map(97..122, & &1)
  @upper_case_chars Enum.map(65..90, & &1)

  def generate_lower_upper_combos() do
    lower_upper_combo =
      Enum.zip(@lower_case_chars, @upper_case_chars)
      |> Enum.reduce(MapSet.new(), fn {a, b}, set_combos ->
        MapSet.put(set_combos, to_string([a, b]))
      end)

    upper_lower_combo =
      Enum.zip(@lower_case_chars, @upper_case_chars)
      |> Enum.reduce(MapSet.new(), fn {a, b}, set_combos ->
        MapSet.put(set_combos, to_string([b, a]))
      end)

    Enum.zip(lower_upper_combo, upper_lower_combo)
    |> Enum.reduce(MapSet.new(), fn {first_combo, second_combo}, combos ->
      MapSet.put(combos, first_combo)
      |> MapSet.put(second_combo)
    end)
  end

  # part 1
  def count_units_after_reactions() do
    {:ok, input} = File.read(@day_five_input_path)

    reaction_combos = generate_lower_upper_combos()

    case has_reaction?(input, reaction_combos) do
      true -> do_count_units_after_reactions(true, input, reaction_combos)
      false -> do_count_units_after_reactions(false, input, reaction_combos)
    end
  end

  def do_count_units_after_reactions(false, result, _), do: String.length(result)

  def do_count_units_after_reactions(true, result, reaction_combos) do
    removed_reaction = remove_reaction(result, reaction_combos)

    has_reaction?(removed_reaction, reaction_combos)
    |> do_count_units_after_reactions(removed_reaction, reaction_combos)
  end

  def has_reaction?(<<first, second, rest::binary>>, reaction_combos) do
    current_combo = to_string([first, second])

    case MapSet.member?(reaction_combos, current_combo) do
      true ->
        true

      false ->
        has_reaction?(to_string([second]) <> <<rest::binary>>, reaction_combos)
    end
  end

  def has_reaction?(_, _), do: false

  def remove_reaction(<<first, second, rest::binary>>, reaction_combos) do
    current_combo = to_string([first, second])

    case MapSet.member?(reaction_combos, current_combo) do
      true ->
        remove_reaction(<<rest::binary>>, reaction_combos)

      false ->
        to_string([first]) <>
          remove_reaction(to_string([second]) <> <<rest::binary>>, reaction_combos)
    end
  end

  def remove_reaction(result, _), do: result

  # part 2
  def remove_chars_combo(_, ""), do: ""

  def remove_chars_combo({lower_char, upper_char}, <<first, rest::binary>>) do
    case char_matches?({lower_char, upper_char}, first) do
      true ->
        remove_chars_combo({lower_char, upper_char}, <<rest::binary>>)

      false ->
        to_string([first]) <> remove_chars_combo({lower_char, upper_char}, <<rest::binary>>)
    end
  end

  def char_matches?({lower_char, upper_char}, first) do
    lower_char == [first] or upper_char == [first]
  end
end
