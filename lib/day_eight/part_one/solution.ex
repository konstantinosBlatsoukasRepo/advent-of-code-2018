defmodule DayEight.PartOne.Solution do
  @parsed_input DayEight.Parser.parse()

  def part_one() do
    do_part_one(@parsed_input)
    |> calculate_sum()
    |> Enum.flat_map(& &1)
    |> Enum.sum()
  end

  def do_part_one(input) do
    case Enum.all?(input, &is_list(&1)) do
      true ->
        input

      false ->
        listified = listify(input)
        do_part_one(listified)
    end
  end

  def listify([]), do: []

  def listify(node) do
    [total_node_childs | [total_node_metadata | rest]] = node

    interest_length_area = total_node_childs + total_node_metadata

    case interest_length_area > length(rest) do
      true ->
        node

      false ->
        case total_node_childs do
          0 ->
            metadata = Enum.take(rest, total_node_metadata)
            rest = Enum.drop(rest, total_node_metadata)

            [metadata | listify(rest)]

          _ ->
            candidate_childs = Enum.take(rest, total_node_childs)

            case Enum.empty?(candidate_childs) do
              true ->
                []

              false ->
                case Enum.all?(candidate_childs, &is_list(&1)) do
                  true ->
                    rest = Enum.drop(rest, interest_length_area)
                    [reduce_complete_node(node, interest_length_area) | listify(rest)]

                  false ->
                    lists_if_any = Enum.take(rest, total_node_childs) |> Enum.filter(&is_list(&1))

                    lists_removed =
                      Enum.take(rest, total_node_childs) |> Enum.reject(&is_list(&1))

                    next_rest = lists_removed ++ Enum.drop(rest, total_node_childs)

                    case Enum.empty?(lists_if_any) do
                      true ->
                        IO.inspect(true_node: node)
                        [total_node_childs | [total_node_metadata | listify(next_rest)]]

                      false ->
                        IO.inspect(node: node)

                        [
                          total_node_childs
                          | [total_node_metadata | [lists_if_any | listify(next_rest)]]
                        ]
                    end
                end
            end
        end
    end
  end

  def reduce_complete_node(complete_node, interest_rest_length) do
    [total_node_childs | [total_node_metadata | rest]] = complete_node

    childs = Enum.take(rest, total_node_childs)

    metadata =
      Enum.take(rest, interest_rest_length)
      |> Enum.reverse()
      |> Enum.take(total_node_metadata)

    childs ++ metadata
  end

  def calculate_sum(listified_input) do
    do_calculate_sum(listified_input, [])
  end

  def do_calculate_sum([], result), do: result

  def do_calculate_sum(listified_input, result) do
    numbers = Enum.filter(listified_input, &is_number/1)

    case numbers do
      [] ->
        listified_input
        |> Enum.flat_map(& &1)
        |> do_calculate_sum(result)

      _ ->
        Enum.reject(listified_input, &is_number/1)
        |> do_calculate_sum([numbers | result])
    end
  end
end
