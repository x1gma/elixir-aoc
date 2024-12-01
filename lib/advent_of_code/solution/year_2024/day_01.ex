defmodule AdventOfCode.Solution.Year2024.Day01 do
  use AdventOfCode.Solution.SharedParse

  @doc """
  Parses the input into a tuple of the left and right input list
  """
  def parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [lv, rv] -> {lv, rv} end)
    |> Enum.unzip()
  end

  def part1(input) do
    input
    |> then(fn {l, r} -> {
      Enum.sort(l),
      Enum.sort(r)
    } end)
    |> then(fn {l, r} -> Enum.zip(l, r) end)
    |> Enum.map(fn {lv, rv} -> abs(lv - rv) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> then(fn {l, r} ->
      lf = Enum.frequencies(l)
      rf = Enum.frequencies(r)

      lf
      |> Map.keys()
      |> Enum.map(fn key -> key * Map.get(lf, key) * Map.get(rf, key, 0) end)
      |> Enum.sum()
    end)
  end
end
