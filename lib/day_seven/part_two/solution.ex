defmodule DaySeven.PartTwo.Solution do
  # each leter takes the value of the capital letter -4

  @last_step_additional_cost 25
  alias DaySeven.PartOne.Solution, as: PartOne

  def part_two(first_step_cost, total_workers) do

    [first_completed | rest] = PartOne.calculate_the_starting_steps()

    initial_steps_costs = initialize_steps_costs(first_step_cost)

  end

  def initialize_steps_costs(first_step_cost) do
    last_step_cost = first_step_cost + @last_step_additional_cost
    letter_values = Enum.map(first_step_cost..last_step_cost, & &1)

    Enum.map(?A..?Z, &to_string([&1]))
    |> Enum.zip(letter_values)
    |> convert_to_map()
  end

  defp convert_to_map(letter_value_pairs) do
    Enum.reduce(letter_value_pairs, %{}, fn letter_value_pair, acc ->
      {letter, value} = letter_value_pair
      Map.put(acc, letter, value)
    end)
  end
end
