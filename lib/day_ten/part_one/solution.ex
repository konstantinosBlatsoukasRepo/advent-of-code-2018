defmodule DayTen.PartOne.Solution do
  @initial_positions DayTen.Parser.parse()

  def solution do
    do_solution(@initial_positions, 0, {@initial_positions, 100_000_000_000_000_000_000_000})
    # |> write_to_file()
  end

  def do_solution(positions, steps, min_positions) do
    new_positions = Enum.map(positions, &position_after_a_second/1)

    new_grid_size =
      min_max(new_positions)
      |> grid_size()

    min_positions = get_min_positions({new_positions, new_grid_size}, min_positions)

    steps = steps + 1

    if new_grid_size == 549 do
      steps
    else
      do_solution(new_positions, steps, min_positions)
    end
  end

  def position_after_a_second(position) do
    [position: {right_left, up_down}, velocity: {x_vel, y_vel}] = position
    new_position = {right_left + x_vel, up_down + y_vel}
    [position: new_position, velocity: {x_vel, y_vel}]
  end

  def min_max(positions) do
    {xs, ys} =
      Enum.reduce(
        positions,
        {[], []},
        fn position, {xs, ys} ->
          [position: {right_left, up_down}, velocity: {_, _}] = position
          {[right_left | xs], [up_down | ys]}
        end
      )

    min_max_xs = Enum.min_max(xs)
    min_max_ys = Enum.min_max(ys)

    {min_max_xs, min_max_ys}
  end

  def grid_size(min_max) do
    {{x_min, x_max}, {y_min, y_max}} = min_max
    (x_max - x_min) * (y_max - y_min)
  end

  def get_min_positions({new_positions, new_grid_size}, min_positions) do
    {old_min_positions, old_min_grid_size} = min_positions

    if new_grid_size < old_min_grid_size do
      {new_positions, new_grid_size}
    else
      {old_min_positions, old_min_grid_size}
    end
  end

  def write_to_file(coordinates) do
    {:ok, file} = File.open("result.txt", [:write])
    {coordinates, _} = coordinates

    Enum.each(
      coordinates,
      fn x ->
        [x_y | _] = x
        {:position, {x, y}} = x_y

        x = Integer.to_string(x)
        y = Integer.to_string(y)

        IO.binwrite(file, "(" <> x <> ", " <> y <> ")" <> "\n")
      end
    )

    File.close(file)
  end
end
