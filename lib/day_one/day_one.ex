defmodule FrequenciesReader do
  import File, only: [read: 1]

  @day_one_input_path "./lib/day_one/day_one_input.txt"

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

defmodule DayOne do
  @frequencies FrequenciesReader.read_frequencies()
  def calibrate_the_frequency(), do: Enum.sum(@frequencies)

  def first_duplicate_frequency() do
    map_set = MapSet.put(MapSet.new(), 0)
    do_first_duplicate_frequency(@frequencies, map_set, 0)
  end

  def do_first_duplicate_frequency([], map_set, current_frequency) do
    do_first_duplicate_frequency(@frequencies, map_set, current_frequency)
  end

  def do_first_duplicate_frequency([head | tail], map_set, current_frequency) do
    updated_frequency = current_frequency + head

    case MapSet.member?(map_set, updated_frequency) do
      true ->
        updated_frequency

      false ->
        do_first_duplicate_frequency(
          tail,
          MapSet.put(map_set, updated_frequency),
          updated_frequency
        )
    end
  end
end
