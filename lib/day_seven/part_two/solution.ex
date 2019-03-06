defmodule DaySeven.PartTwo.Solution do
  alias DaySeven.PartOne.GraphBuilder
  alias DaySeven.PartOne.Solution, as: PartOne

  alias DaySeven.PartTwo.CostsCalculator

  @graph GraphBuilder.build_steps_graph()
  @initial_steps_costs CostsCalculator.initialize_steps_costs()
  @total_workers 2

  def part_two() do
    available = PartOne.calculate_the_starting_steps()
    do_part_two(available, [], 0, @initial_steps_costs)
  end

  def do_part_two(available, completed, total_completed, current_costs) do
    steps_for_reduction = Enum.take(available, @total_workers)

    updated_costs = decrease_work_amount(steps_for_reduction, current_costs)

    completed_steps = extract_completed_steps(updated_costs)

    total_completed = length(completed_steps)


  end

  def decrease_work_amount([], current_costs), do: current_costs

  def decrease_work_amount(steps_for_reduction, current_costs) do
    [current_step | rest] = steps_for_reduction

    current_value = Map.get(current_costs, current_step)

    updated_costs = Map.put(current_costs, current_step, current_value - 1)

    decrease_work_amount(rest, updated_costs)
  end

  def extract_completed_steps(updated_costs) do
    Enum.reduce(updated_costs, [], fn {k, v}, acc ->
      case v == 0 do
        true -> [k | acc]
        false -> acc
      end
    end)
    |> Enum.sort()
  end
end
