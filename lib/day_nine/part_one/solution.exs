defmodule DayNine.PartOne.Solution do
  @total_players 13

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

    new_context([0], 0, nil, scores)
  end

  defp insert_marble(1, game_context) do
    scores = Keyword.get(game_context, :scores)

    new_context([0, 1], 1, 1, scores)
  end

  defp insert_marble(new_marble, game_context) when rem(new_marble, 23) == 0 do
    [
      circle: previous_circle,
      current_index: current_index,
      player_id: player_id,
      scores: scores
    ] = game_context

    index_for_removal = calculate_index_for_removal(previous_circle, current_index)

    {seventh_value, updated_circle} = List.pop_at(previous_circle, index_for_removal)

    new_score = new_marble + seventh_value

    next_player_id = calculate_next_player_id(player_id)

    new_total_scores = Map.update(scores, next_player_id, new_score, &(&1 + new_score))

    new_context(updated_circle, index_for_removal, next_player_id, new_total_scores)
  end

  defp insert_marble(new_marble, game_context) do
    [
      circle: previous_circle,
      current_index: current_index,
      player_id: previous_palyer_id,
      scores: scores
    ] = game_context

    # this can be removed, increment at each addiotion expect when rem 23
    previous_length = length(previous_circle)

    next_player_id = calculate_next_player_id(previous_palyer_id)

    next_current_index = rem(current_index + 2, previous_length)

    case next_current_index do
      0 ->
        new_circle = previous_circle ++ [new_marble]
        new_context(new_circle, length(new_circle) - 1, next_player_id, scores)

      _ ->
        List.insert_at(previous_circle, next_current_index, new_marble)
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
        list_length = length(previous_circle)
        index_for_removal + list_length
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

IO.inspect(DayNine.PartOne.Solution.play(7999))
