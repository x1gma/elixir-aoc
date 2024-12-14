defmodule AdventOfCode.Solution.Year2024.Day04 do

  # TODO: This is so sloooooooooow
  # - probably should prune words earlier

  @spec part1(binary()) :: non_neg_integer()
  def part1(input) do
    grid = parse_grid(input)

    grid_indices(grid)
    |> Enum.map(fn {x, y} -> {x, y, get_char(grid, {x, y})} end)
    |> Enum.filter(fn {_, _, c} -> c == "X" end)
    |> Enum.flat_map(fn {x, y, _} ->
      get_line_indices(grid, x, y, 4)
      |> Enum.concat(get_diagonal_indices(grid, x, y, 4))
      |> Enum.map(&get_word(grid, &1))
    end)
    |> Enum.count(fn {_, w} -> w == "XMAS" end)
  end

  @spec part2(binary()) :: non_neg_integer()
  def part2(input) do
    grid = parse_grid(input)

    grid_indices(grid)
    |> Enum.map(fn {x, y} -> {x, y, get_char(grid, {x, y})} end)
    |> Enum.filter(fn {_, _, c} -> c == "M" end)
    |> Enum.flat_map(fn {x, y, _} ->
      get_diagonal_indices(grid, x, y, 3)
      |> Enum.map(&get_word(grid, &1))
    end)
    |> Enum.filter(fn {_, w} -> w == "MAS" end)
    |> Enum.map(fn {indices, _} -> Enum.at(indices, 1) end)
    |> Enum.frequencies()
    |> Enum.filter(fn {_, count} -> count == 2 end)
    |> Enum.count()
  end

  @spec parse_grid(binary()) :: %{content: String.t(), xlen: integer(), ylen: integer()}
  defp parse_grid(input) do
    content_lines = String.split(input)

    %{
      content: Enum.join(content_lines),
      xlen: String.length(Enum.at(content_lines, 0)),
      ylen: length(content_lines)
    }
  end

  @spec get_line_indices(
          %{content: String.t(), xlen: integer(), ylen: integer()},
          integer(),
          integer(),
          integer()
        ) :: list({integer(), integer()})
  defp get_line_indices(grid, xstart, ystart, length) do
    ypos = Enum.to_list(ystart..(ystart + length - 1))
    yneg = Enum.to_list(ystart..(ystart - length + 1)//-1)
    xpos = Enum.to_list(xstart..(xstart + length - 1))
    xneg = Enum.to_list(xstart..(xstart - length + 1)//-1)

    [
      # vertical top
      ypos |> Enum.map(&{xstart, &1}),
      # horizontal right
      xpos |> Enum.map(&{&1, ystart}),
      # vertical down
      yneg |> Enum.map(&{xstart, &1}),
      # horizontal left
      xneg |> Enum.map(&{&1, ystart})
    ]
    |> Enum.filter(&in_grid_bounds(grid, &1))
  end

  @spec get_diagonal_indices(
          %{content: String.t(), xlen: integer(), ylen: integer()},
          integer(),
          integer(),
          integer()
        ) :: list({integer(), integer()})
  defp get_diagonal_indices(grid, xstart, ystart, length) do
    ypos = Enum.to_list(ystart..(ystart + length - 1))
    yneg = Enum.to_list(ystart..(ystart - length + 1)//-1)
    xpos = Enum.to_list(xstart..(xstart + length - 1))
    xneg = Enum.to_list(xstart..(xstart - length + 1)//-1)

    [
      # diagonal top right
      ypos |> Enum.zip(xpos) |> Enum.map(fn {y, x} -> {x, y} end),
      # diagonal bottom right
      xpos |> Enum.zip(yneg) |> Enum.map(fn {x, y} -> {x, y} end),
      # diagonal bottom left
      yneg |> Enum.zip(xneg) |> Enum.map(fn {y, x} -> {x, y} end),
      # diagonal top left
      xneg |> Enum.zip(ypos) |> Enum.map(fn {x, y} -> {x, y} end)
    ]
    |> Enum.filter(&in_grid_bounds(grid, &1))
  end

  @spec in_grid_bounds(
          %{content: String.t(), xlen: integer(), ylen: integer()},
          list({integer(), integer()})
        ) :: boolean
  defp in_grid_bounds(grid, indices) do
    Enum.all?(indices, fn {x, y} -> x >= 0 && x < grid.xlen && y >= 0 && y < grid.ylen end)
  end

  @spec get_char(%{content: String.t(), xlen: integer(), ylen: integer()}, {integer(), integer()}) ::
          String.t()
  defp get_char(grid, {x, y}) do
    String.at(grid.content, y * grid.xlen + x)
  end

  @spec get_word(
          %{content: String.t(), xlen: integer(), ylen: integer()},
          list({integer(), integer()})
        ) :: {list({integer(), integer()}), String.t()}
  defp get_word(grid, indices) do
    {indices,
     indices
     |> Enum.map(&get_char(grid, &1))
     |> Enum.join()}
  end

  @spec grid_indices(%{content: String.t(), xlen: integer(), ylen: integer()}) ::
          list({integer(), integer()})
  defp grid_indices(grid) do
    x = Enum.to_list(0..(grid.xlen - 1))
    y = Enum.to_list(0..(grid.ylen - 1))
    for x <- x, y <- y, do: {x, y}
  end
end
