defmodule DayOne do
  import File, only: [read: 1]

  @day_one_input_path "./lib/day_one/day_one_input.txt"

  def calibrate_the_frequency(), do: Enum.sum(read_frequencies())

  def first_duplicate_frequency() do
    map_set = MapSet.put(MapSet.new(), 0)
    do_first_duplicate_frequency(read_frequencies(), map_set, 0)
  end

  def do_first_duplicate_frequency([], map_set, current_frequency) do
    do_first_duplicate_frequency(read_frequencies(), map_set, current_frequency)
  end

  def do_first_duplicate_frequency(frequencies, map_set, current_frequency) do
    [head | tail] = frequencies
    current_frequency = current_frequency + head

    case MapSet.member?(map_set, current_frequency) do
      true ->
        current_frequency

      false ->
        do_first_duplicate_frequency(
          tail,
          MapSet.put(map_set, current_frequency),
          current_frequency
        )
    end
  end

  @spec read_frequencies() :: atom() | [any()]
  def read_frequencies() do
    case read(@day_one_input_path) do
      {:ok, contents} ->
        contents
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)

      {:error, reason} ->
        reason
    end
  end
end
