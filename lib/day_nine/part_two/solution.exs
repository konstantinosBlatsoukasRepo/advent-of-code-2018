defmodule DayNine.PartTwo.Solution do
  @total_players 9

  def play(total_turns) do
    {_, players_scores} = initialize_scores()

    Stream.map(0..total_turns, & &1)
    |> Enum.reduce(
      [
        circle: nil,
        current_index: nil,
        player_id: nil,
        scores: players_scores
      ],
      &insert_marble/2
    )
    |> Keyword.get(:scores)
    |> Map.values()
    |> Enum.max()
  end

  defp initialize_scores do
    Enum.map_reduce(1..@total_players, Map.new(), &{&1, Map.put(&2, &1, 0)})
  end

  defp insert_marble(0, game_context) do
    scores = Keyword.get(game_context, :scores)

    new_context(%{0 => 0}, 0, nil, scores)
  end

  defp insert_marble(1, game_context) do
    scores = Keyword.get(game_context, :scores)

    new_context(%{0 => 0, 1 => 1}, 1, 1, scores)
  end

  defp insert_marble(new_marble, game_context) when rem(new_marble, 23) == 0 do
    [
      circle: previous_circle,
      current_index: current_index,
      player_id: player_id,
      scores: scores
    ] = game_context

    index_for_removal = calculate_index_for_removal(previous_circle, current_index)

    seventh_value = Map.get(previous_circle, index_for_removal)
    updated_circle = Map.delete(previous_circle, index_for_removal)

    updated_circle =
      Enum.reduce(
        Enum.map(index_for_removal..(Map.size(previous_circle) - 1), & &1),
        previous_circle,
        fn x, acc ->
          value = Map.get(acc, x + 1)
          Map.put(acc, x, value)
        end
      )
      |> Map.delete(Map.size(updated_circle) - 1)

    IO.inspect(new_marble: new_marble)
    IO.inspect(seventh_value: seventh_value)

    new_score = new_marble + seventh_value

    next_player_id = calculate_next_player_id(player_id)

    new_total_scores = Map.update(scores, next_player_id, new_score, &(&1 + new_score))

    new_context(updated_circle, index_for_removal, next_player_id, new_total_scores)
  end

  defp insert_marble(new_marble, game_context) do
    IO.inspect(new_marble)

    [
      circle: previous_circle,
      current_index: current_index,
      player_id: previous_palyer_id,
      scores: scores
    ] = game_context |> IO.inspect()

    previous_length = Map.size(previous_circle)

    next_player_id = calculate_next_player_id(previous_palyer_id)

    next_current_index = rem(current_index + 2, previous_length)

    IO.inspect(next_current_index: next_current_index)

    case next_current_index do
      0 ->
        new_circle = Map.put(previous_circle, previous_length, new_marble)
        new_context(new_circle, Map.size(new_circle) - 1, next_player_id, scores)

      _ ->
        Map.put(previous_circle, next_current_index + 1, new_marble)
        |> new_context(next_current_index, next_player_id, scores)
    end
  end

  defp calculate_next_player_id(previous_player_id) do
    cond do
      previous_player_id + 1 > @total_players -> 1
      true -> previous_player_id + 1
    end
  end

  defp calculate_index_for_removal(previous_circle, current_index) do
    index_for_removal = current_index - 7

    case index_for_removal >= 0 do
      true ->
        index_for_removal

      false ->
        map_size = Map.size(previous_circle)
        index_for_removal + map_size
    end
  end

  defp new_context(circle, current_index, player_id, scores) do
    [
      circle: circle,
      current_index: current_index,
      player_id: player_id,
      scores: scores
    ]
  end
end

IO.inspect(DayNine.PartTwo.Solution.play(25))
