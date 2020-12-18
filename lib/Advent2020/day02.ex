defmodule Advent2020.Day02 do
  def part1() do
    solve1(input())
  end

  def part2() do
    solve2(input())
  end

  def parse_line(line) do
    line_regex = ~r{(\d+)-(\d+) (\w): (\w+)}
    [start, stop, letter, password] = Regex.run(line_regex, line, capture: :all_but_first)
    {String.to_integer(start), String.to_integer(stop), letter, password}
  end

  def input() do
    File.stream!("inputs/02")
    |> Enum.map(&parse_line/1)
  end

  def is_valid({start, stop, letter, password}) do
    count =
      password
      |> String.graphemes()
      |> Enum.count(&(&1 == letter))

    start <= count and count <= stop
  end

  def solve1(input) do
    input
    |> Enum.filter(&is_valid/1)
    |> Enum.count()
  end

  def is_valid2({first_pos, second_pos, letter, password}) do
    letters = String.graphemes(password)
    first = Enum.at(letters, first_pos - 1)
    second = Enum.at(letters, second_pos - 1)

    (first == letter or second == letter) and first != second
  end

  def solve2(input) do
    input
    |> Enum.filter(&is_valid2/1)
    |> Enum.count()
  end
end
