defmodule DaySeven.Parser do
  @day_seven_input_path "./lib/day_seven/day_seven_input.txt"
  # @day_seven_input_path "./lib/day_seven/test_seven.txt"
  @split_list ["Step", "must", "be", "finished", "before", " ", "step", "can", "gin."]

  def parse() do
    {:ok, input} = File.read(@day_seven_input_path)

    String.split(input, "\n")
    |> Stream.flat_map(fn line -> String.split(line, @split_list) end)
    |> Enum.filter(&(&1 != ""))
    |> create_dependency_pairs()
    |> create_dependency_map()
  end

  def create_dependency_pairs(dep_list) do
    do_create_dependency_pairs(dep_list, [])
  end

  def do_create_dependency_pairs([], result), do: result

  def do_create_dependency_pairs(dep_list, result) do
    [depends_on | [dependent | rest]] = dep_list
    do_create_dependency_pairs(rest, [{dependent, depends_on: depends_on} | result])
  end

  def create_dependency_map(dependency_pairs) do
    Enum.reduce(dependency_pairs, %{}, fn {dependent, [depends_on: dependency]}, acc ->
      case Map.get(acc, dependent) do
        nil ->
          Map.put(acc, dependent, [dependency])

        result ->
          Map.put(acc, dependent, [dependency | result])
      end
    end)
  end
end
