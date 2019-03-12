defmodule DayEight.PartOne.Solution do
  @parsed_input DayEight.Parser.parse()

  def part_one() do
    do_part_one(@parsed_input)
    |> List.flatten()
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
                case node_complete?(candidate_childs) do
                  true ->
                    rest = Enum.drop(rest, interest_length_area)

                    [reduce_complete_node(node, interest_length_area) | listify(rest)]

                  false ->
                    next_rest = compute_next_rest(rest, total_node_childs)

                    lists_if_any = keep_lists(rest, total_node_childs)

                    case Enum.empty?(lists_if_any) do
                      true ->
                        [total_node_childs | [total_node_metadata | listify(next_rest)]]

                      false ->
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

  def compute_next_rest(rest, total_node_childs) do
    Enum.take(rest, total_node_childs)
    |> Enum.reject(&is_list(&1))
    |> Enum.concat(Enum.drop(rest, total_node_childs))
  end

  def node_complete?(candidate_childs), do: Enum.all?(candidate_childs, &is_list(&1))

  def keep_lists(rest, total_node_childs), do: Enum.take(rest, total_node_childs) |> Enum.filter(&is_list(&1))
end
