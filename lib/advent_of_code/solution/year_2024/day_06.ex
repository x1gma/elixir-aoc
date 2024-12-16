defmodule AdventOfCode.Solution.Year2024.Day06 do
  def part1(input) do
    parsed = parse(input)
    {initial_x, initial_y} = parsed.guard

    Stream.resource(
      fn -> [{initial_x, initial_y, parsed.direction}] end,
      fn path ->
        first = List.first(path)
        {x, y, direction} = first
        {new_x, new_y, new_direction} = move(x, y, direction, parsed.obstacles)

        if x < 0 || x >= parsed.xlen || y < 0 || y >= parsed.ylen do
          {:halt, path}
        else
          {
            [{new_x, new_y, new_direction}],
            [{new_x, new_y, new_direction} | path]
          }
        end
      end,
      fn _ -> nil end
    )
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()
    |> Enum.count()
  end


  def part2(input) do
    parsed = parse(input)
    {initial_x, initial_y} = parsed.guard

    original_path = Stream.resource(
      fn -> [{initial_x, initial_y, parsed.direction}] end,
      fn path ->
        first = List.first(path)
        {x, y, direction} = first
        {new_x, new_y, new_direction} = move(x, y, direction, parsed.obstacles)

        if x < 0 || x >= parsed.xlen || y < 0 || y >= parsed.ylen do
          {:halt, path}
        else
          {
            [{new_x, new_y, new_direction}],
            [{new_x, new_y, new_direction} | path]
          }
        end
      end,
      fn _ -> nil end
    )
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()

    original_path
    |> Enum.filter(fn {x, y} -> !Enum.member?(parsed.obstacles, {x, y}) && {x, y} != parsed.guard end)
    |> Task.async_stream(fn {x, y} ->
      obstacles = [{x, y} | parsed.obstacles]
      Stream.resource(
        fn -> [{initial_x, initial_y, parsed.direction}] end,
        fn path ->
          first = List.first(path)
          {x, y, direction} = first
          {new_x, new_y, new_direction} = move(x, y, direction, obstacles)
          path_length = path |> Enum.count()

          if path_length > 15000 || x < 0 || x >= parsed.xlen || y < 0 || y >= parsed.ylen do
            {:halt, path}
          else
            {
              [{new_x, new_y, new_direction}],
              [{new_x, new_y, new_direction} | path]
            }
          end
        end,
        fn _ -> nil end
      )
      |> Enum.count() == 15000
    end)
    |> Enum.filter(fn {_, result} -> result end)
    |> Enum.count()
  end

  def move(x, y, direction, obstacles) do
    {new_x, new_y} =
      case direction do
        :top -> {x, y - 1}
        :right -> {x + 1, y}
        :bottom -> {x, y + 1}
        :left -> {x - 1, y}
      end

    if Enum.member?(obstacles, {new_x, new_y}) do
      {x, y, rotate(direction)}
    else
      {new_x, new_y, direction}
    end
  end

  def rotate(direction) do
    case direction do
      :top -> :right
      :right -> :bottom
      :bottom -> :left
      :left -> :top
    end
  end

  defp parse(input) do
    content_lines = String.split(input)
    content = Enum.join(content_lines)
    xlen = String.length(Enum.at(content_lines, 0))
    ylen = length(content_lines)

    chars =
      content
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, idx} ->
        x = rem(idx, xlen)
        y = div(idx, xlen)
        {char, x, y}
      end)
      |> Enum.group_by(fn {char, _, _} -> char end)

    %{
      direction: :top,
      guard: chars["^"] |> Enum.map(fn {_, x, y} -> {x, y} end) |> List.first(),
      obstacles: chars["#"] |> Enum.map(fn {_, x, y} -> {x, y} end),
      xlen: xlen - 1,
      ylen: ylen - 1
    }
  end
end
