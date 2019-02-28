defmodule DaySeven.PartOne.Solution do
  def build_steps_graph() do
    DaySeven.Parser.parse()
    |> Enum.reduce(%{}, fn {step, dependencies}, graph ->
      build_adjecent_steps(step, dependencies, graph)
    end)
  end

  def build_adjecent_steps(step, dependency, graph) when is_binary(dependency) do
    case Map.get(graph, dependency) do
      nil -> Map.put(graph, dependency, step)
      steps -> Map.put(graph, dependency, [step | steps])
    end
  end

  def build_adjecent_steps(step, dependencies, graph) do
    Enum.reduce(dependencies, graph, fn dependency, graph ->
      case Map.get(graph, dependency) do
        nil -> Map.put(graph, dependency, [step])
        steps -> Map.put(graph, dependency, [step | steps])
      end
    end)
  end
end
