defmodule DayFive do
  @day_five_input_path "./lib/day_five/day_five_input.txt"
  # @day_five_input_path "./lib/day_five/test_five.txt"
  @lower_case_chars Enum.map(97..122, & &1)
  @upper_case_chars Enum.map(65..90, & &1)

  def generate_lower_upper_combos() do
    Enum.zip(@lower_case_chars, @upper_case_chars)
    |> Enum.reduce(MapSet.new(), fn {a, b}, set_combos ->
      MapSet.put(set_combos, to_string([a, b]))
    end)
  end

  def generate_upper_lower_combos() do
    Enum.zip(@lower_case_chars, @upper_case_chars)
    |> Enum.reduce(MapSet.new(), fn {a, b}, set_combos ->
      MapSet.put(set_combos, to_string([b, a]))
    end)
  end

  def generate_combos() do
    lower_upper_combos = generate_lower_upper_combos()

    upper_lower_combos = generate_upper_lower_combos()

    MapSet.union(lower_upper_combos, upper_lower_combos)
  end

  # part 1
  def part_one() do
    {:ok, input} = File.read(@day_five_input_path)
    count_units_after_reactions(input)
  end

  def count_units_after_reactions(input) do
    reaction_combos = generate_combos()

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
  def part_two() do
    {:ok, input} = File.read(@day_five_input_path)
    calculate_the_most_problematic_unit(input)
  end

  def calculate_the_most_problematic_unit(input) do
    MapSet.to_list(generate_lower_upper_combos())
    |> Enum.map(fn x ->
      <<lower_char, upper_case>> = x
      do_calculate_the_most_problematic_unit({[lower_char], [upper_case]}, input)
    end)
    |> Enum.min()
  end

  def do_calculate_the_most_problematic_unit({lower_char, upper_char}, polymer) do
    remove_chars_combo({lower_char, upper_char}, polymer)
    |> count_units_after_reactions()
  end

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
