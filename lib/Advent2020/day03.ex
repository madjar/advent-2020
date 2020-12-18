defmodule Advent2020.Day03 do
  use Advent2020

  def parse_line(line) do
    line
    |> String.trim()
    |> String.graphemes()
  end

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.to_list()
  end

  # def get(input, right, down) do
  #   line = Enum.at(input, down)
  #   Enum.at(line, rem(right, 31))
  # end

  def solve1(input) do
    count_trees(input, 3, 1)
  end

  def count_trees(input, slope_right, slope_down) do
    input
    |> Enum.with_index()
    |> Enum.filter(fn {_line, index} -> rem(index, slope_down) == 0 end)
    |> Enum.map(fn {line, index} ->
      Enum.at(line, rem(div(index, slope_down) * slope_right, length(line)))
    end)
    |> Enum.count(&(&1 == "#"))
  end

  def solve2(input) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right, down} -> count_trees(input, right, down) end)
    |> Enum.reduce(&*/2)
  end

  def example do
    ~S"..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#"
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.to_list()
  end
end
