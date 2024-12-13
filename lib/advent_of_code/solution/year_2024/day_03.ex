defmodule AdventOfCode.Solution.Year2024.Day03 do
  def part1(input) do
    Regex.scan(~r/mul\((\d+)\,(\d+)\)/, input)
    |> Enum.reduce(0, fn [_, left, right], acc -> acc + String.to_integer(left) * String.to_integer(right) end)
  end

  def part2(input) do
    Regex.scan(~r/mul\((\d+)\,(\d+)\)|don't\(\)|do\(\)/, input)
    |> Enum.reduce({:enabled, 0}, fn
      ["do()" | _], {_state, acc} -> {:enabled, acc}
      ["don't()" | _], {_state, acc} -> {:disabled, acc}
      [_, left, right], {:enabled, acc} -> {:enabled, acc + String.to_integer(left) * String.to_integer(right)}
      _, acc -> acc
    end)
    |> elem(1)
  end
end
