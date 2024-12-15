defmodule AdventOfCode.Solution.Year2024.Day05 do
  def part1(input) do
    {rules, pages} = parse(input)

    pages
    |> Enum.filter(fn page -> apply_rules(rules, page) end)
    |> Enum.map(&get_middle_page_number/1)
    |> Enum.sum()
  end

  def apply_rules(rules, pages) do
    rules
    |> Enum.all?(fn rule -> apply_rule(rule, pages) end)
  end

  def get_middle_page_number(pages) do
    index = (map_size(pages) - 1) / 2

    Map.to_list(pages)
    |> Enum.filter(fn {_, v} -> v == index end)
    |> Enum.map(fn {k, _} -> k end)
    |> List.first()
    |> String.to_integer()
  end

  def apply_rule(rule, pages) do
    {left, right} = rule
    left_index = Map.get(pages, left)
    right_index = Map.get(pages, right)
    left_index == nil || right_index == nil || left_index < right_index
  end

  def parse(input) do
    grouped_lines =
      String.split(input)
      |> Enum.group_by(fn line ->
        if String.contains?(line, "|") do
          :rule
        else
          if String.contains?(line, ",") do
            :page
          else
            :other
          end
        end
      end)

    rules =
      grouped_lines[:rule]
      |> Enum.map(fn line -> String.split(line, "|") end)
      |> Enum.map(fn [l, r] -> {l, r} end)

    pages =
      grouped_lines[:page]
      |> Enum.map(fn line -> String.split(line, ",") end)
      |> Enum.map(&Enum.with_index(&1))
      |> Enum.map(&Enum.group_by(&1, fn {v, _} -> v end, fn {_, i} -> i end))
      |> Enum.map(fn map ->
        Map.to_list(map)
        |> Map.new(fn {k, [v]} -> {k, v} end)
      end)

    {rules, pages}
  end

  def part2(input) do
    {rules, pages} = parse(input)

    pages
    |> Enum.filter(fn page -> !apply_rules(rules, page) end)
    |> Enum.map(fn page -> sort_page(rules, page) end)
    |> Enum.map(&get_middle_page_number/1)
    |> Enum.sum()
  end

  def sort_page(rules, page) do
    page_elements = page
    |> Map.to_list()
    |> Enum.sort(fn {_, i1}, {_, i2} -> i1 < i2 end)
    |> Enum.map(fn {k, _} -> k end)

    filtered_rules = rules
    |> Enum.filter(fn {left, right} -> Enum.member?(page_elements, left) && Enum.member?(page_elements, right) end)

    page_elements
    |> Enum.sort(fn left, right ->
      if (Enum.member?(filtered_rules, {left, right})) do
        true
      else
        false
      end
    end)
    |> Enum.with_index()
    |> Enum.group_by(fn {v, _} -> v end, fn {_, i} -> i end)
    |> Map.to_list()
    |> Map.new(fn {k, [v]} -> {k, v} end)
  end

end
