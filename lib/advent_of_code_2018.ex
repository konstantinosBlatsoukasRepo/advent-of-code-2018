defmodule AdventOfCode2018 do
  import File, only: [read: 1]

  @moduledoc """
  Documentation for AdventOfCode2018.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AdventOfCode2018.hello()
      :world

  """
  def hello do
    :world
  end

  def read_input(day_input_file) do
    case read(day_input_file) do
      {:ok, contents} ->
        contents
        |> String.split("\r\n")

      {:error, reason} ->
        reason
    end
  end
end
