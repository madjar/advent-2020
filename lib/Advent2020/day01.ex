defmodule Advent2020.Day01 do
  def part1() do
    solve1(input())
  end

  def part2() do
    solve2(input())
  end

  def input() do
    File.stream!("inputs/01")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def solve1(input) do
    input
    |> find_two_entries()
    |> format_output()
  end

  defp find_two_entries(list) do
    try do
      Enum.reduce(
        list,
        MapSet.new(),
        fn item, set ->
          if MapSet.member?(set, 2020 - item) do
            throw(item)
          else
            MapSet.put(set, item)
          end
        end
      )
    catch
      solution -> solution
    end
  end

  defp format_output(solution) do
    solution * (2020 - solution)
  end

  defp find_three_entries(list) do
    try do
      Enum.reduce(
        list,
        {[], %{}},
        fn item, {single_values, map_of_2sum} ->
          case Map.fetch(map_of_2sum, 2020 - item) do
            {:ok, entries} ->
              throw([item | entries])

            :error ->
              {[item | single_values],
               single_values
               |> Enum.map(&{&1 + item, [&1, item]})
               |> Map.new()
               |> Map.merge(map_of_2sum)}
          end
        end
      )
    catch
      solution -> solution
    end
  end

  defp solve2(input) do
    input
    |> find_three_entries()
    |> Enum.reduce(1, &*/2)
  end
end
