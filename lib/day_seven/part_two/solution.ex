defmodule DaySeven.PartTwo.Solution do
  alias DaySeven.PartOne.Solution, as: PartOne
  alias DaySeven.PartTwo.CostsCalculator

  @initial_steps_costs CostsCalculator.initialize_steps_costs()
  @total_workers 5

  def part_two() do
    available = PartOne.calculate_the_starting_steps()
    do_part_two(available, [],  @initial_steps_costs, 0)
  end

  def do_part_two([], _, _, total_duration) , do: total_duration
  def do_part_two(available, completed, current_costs, total_duration) do
    steps_for_reduction = Enum.take(available, @total_workers)

    IO.inspect(steps_for_reduction: steps_for_reduction)

    updated_costs = decrease_work_amount(steps_for_reduction, current_costs)

    next_completed_steps = extract_completed_steps(updated_costs)

    case next_completed_steps do
      [] ->
        do_part_two(available, completed, updated_costs, total_duration + 1)

      more_steps ->
        next_completed_steps = more_steps ++ completed

        extra_steps = Enum.flat_map(more_steps, &PartOne.sorted_adjacents_to_step(&1, completed))

        available = available ++ extra_steps

        updated_costs = remove_from_steps_costs(more_steps, updated_costs)

        available = Enum.reject(available, &Enum.member?(next_completed_steps, &1))
        |> Enum.filter(&PartOne.all_dependecies_completed?(&1, next_completed_steps))

        do_part_two(available, next_completed_steps, updated_costs, total_duration + 1)
    end
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

  def remove_from_steps_costs([], updated_costs), do: updated_costs

  def remove_from_steps_costs(more_steps, updated_costs) do
    [current_step | rest] = more_steps

    updated_costs = Map.delete(updated_costs, current_step)

    remove_from_steps_costs(rest, updated_costs)
  end
end
