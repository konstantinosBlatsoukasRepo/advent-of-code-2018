defmodule DaySeven.PartOne.Solution do
  alias DaySeven.PartOne.GraphBuilder
  @steps_dependencies DaySeven.Parser.parse()
  @graph GraphBuilder.build_steps_graph()

  def part_one() do
    [first_completed | rest] =
      calculate_the_starting_steps()
      |> Enum.sort()

    available =
      (sorted_adjacents_to_step(first_completed, []) ++ rest)
      |> Enum.sort()

    do_part_one(available, [first_completed])
    |> Enum.reverse()
    |> Enum.join()
  end

  def do_part_one(available_steps, completed_steps) do
    next_completed_step = find_the_next_completed_step(available_steps, completed_steps)

    case Map.get(@graph, next_completed_step) do
      nil ->
        [next_completed_step | completed_steps]

      _ ->
        available_steps = Enum.reject(available_steps, &(&1 == next_completed_step))
        available_steps = sorted_adjacents_to_step(next_completed_step, available_steps)

        completed_steps = [next_completed_step | completed_steps]

        do_part_one(available_steps, completed_steps)
    end
  end

  def calculate_the_starting_steps() do
    steps = extract_all_possible_steps()

    adjecent_steps = extract_all_adjacent_steps()

    Enum.reject(steps, &MapSet.member?(adjecent_steps, &1))
  end

  def extract_all_adjacent_steps() do
    @graph
    |> Map.values()
    |> Enum.flat_map(& &1)
    |> MapSet.new()
  end

  def extract_all_possible_steps() do
    @graph
    |> Map.keys()
    |> MapSet.new()
  end

  def sorted_adjacents_to_step(next_completed_step, available_steps) do
    completed_step_adjacents =
      case Map.get(@graph, next_completed_step) do
        nil -> [next_completed_step]
        res -> Enum.reject(res, &Enum.member?(available_steps, &1))
      end

    Enum.sort(completed_step_adjacents ++ available_steps)
  end

  def all_dependecies_completed?(step, completed_steps) do
    case Enum.member?(completed_steps, step) do
      true -> true
      false -> do_all_dependecies_completed?(step, completed_steps)
    end
  end

  def do_all_dependecies_completed?(step, completed_steps) do
    case Map.get(@steps_dependencies, step) do
      nil -> true
      result -> Enum.all?(result, &Enum.member?(completed_steps, &1))
    end
  end

  def find_the_next_completed_step([], _), do: :next_not_found

  def find_the_next_completed_step(available_steps, completed_steps) do
    [current_step | rest] = available_steps

    case all_dependecies_completed?(current_step, completed_steps) do
      true -> current_step
      false -> find_the_next_completed_step(rest, completed_steps)
    end
  end
end
