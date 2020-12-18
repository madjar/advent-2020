defmodule Advent2020.Day06 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def answers_in_group(group) do
    group
    |> Stream.flat_map(&String.graphemes/1)
    |> MapSet.new()
    |> MapSet.size()
  end

  def solve1(input) do
    input
    |> Enum.map(&answers_in_group/1)
    |> Enum.sum()
  end

  def answer_that_everyone_answered_yes(group) do
    group
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.size()
  end

  def solve2(input) do
    input
    |> Enum.map(&answer_that_everyone_answered_yes/1)
    |> Enum.sum()
  end
end
