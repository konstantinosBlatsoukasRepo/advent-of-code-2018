defmodule DayEight.TreeBuilder do
  alias DayEight.Node
  @parsed_input DayEight.Parser.parse()

  def build() do
    [total_node_childs | [total_node_metadata | rest]] = @parsed_input

  end

  # def do_build(0, 0, node), do: node

  # def do_build({total_node_childs, total_node_metadata}, rest) do

  #   case  do
  #      ->

  #   end
  # end
end
