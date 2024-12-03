defmodule AdventOfCode.Solution.Year2024.Day02 do
  use AdventOfCode.Solution.SharedParse

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.to_list()
    end)
  end

  def part1(input) do
    input
    |> Stream.map(&get_error_transitions/1)
    |> Stream.map(fn transitions -> Enum.count(transitions, &(!&1)) end)
    |> Enum.count(&(&1 == 0))
  end

  defp get_error_transitions(levels) do
    levels
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [curr, next] -> next - curr end)
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(&is_safe_diff/1)
  end

  defp is_safe_diff([prev, next]) do
    is_safe_range(prev) && is_safe_range(next) && is_same_sign(prev, next)
  end

  defp is_safe_range(val) do
    (val >= 1 && val <= 3) || (val <= -1 && val >= -3)
  end

  defp is_same_sign(first, second) do
    (first > 0 && second > 0) || (first < 0 && second < 0) || (first == 0 && second == 0)
  end

  def part2(input) do
    input
    |> Stream.map(fn levels ->
      0..Enum.count(levels)
      |> Stream.map(fn i -> List.delete_at(levels, i) end)
      |> Stream.map(&get_error_transitions/1)
      |> Stream.map(fn transitions -> Enum.count(transitions, &(!&1)) end)
      |> Enum.min
    end)
    |> Enum.count(&(&1 == 0))
  end

end
