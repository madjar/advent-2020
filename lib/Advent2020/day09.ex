defmodule Advent2020.Day09 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solve1(input) do
    input
    |> Enum.chunk_every(26, 1)
    |> Enum.find(fn l ->
      val = List.last(l)
      prevs = Enum.take(l, 25)
      pairs = for x <- prevs, y <- prevs, x != y, x + y == val, do: {x, y}
      Enum.empty?(pairs)
    end)
    |> List.last()
  end

  def solve2(input) do
    target = 466_456_641

    List.first(
      for i <- 0..(Enum.count(input) - 1),
          j <- (i + 1)..(Enum.count(input) - 1),
          j < target,
          set = Enum.slice(input, i..j),
          Enum.sum(set) == target,
          do: Enum.max(set) + Enum.min(set)
    )
  end
end
