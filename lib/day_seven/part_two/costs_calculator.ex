defmodule DaySeven.PartTwo.CostsCalculator do
  @last_step_additional_cost 25
  # @first_step_cost 1
  @first_step_cost 60

  def initialize_steps_costs() do
    last_step_cost = @first_step_cost + @last_step_additional_cost
    letter_values = Enum.map(@first_step_cost..last_step_cost, & &1)

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
