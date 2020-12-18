defmodule Advent2020.Day10 do
  use Advent2020

  def input() do
    raw_input() |> parse()

  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solve1(input) do
    distribution = input |> distributions()

    distribution[1] * distribution[3]
  end

  def distributions(input) do
    (input ++ [0, Enum.max(input) + 3])
    |> Enum.sort()
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [x, y] -> y - x end)
    |> Enum.frequencies()
  end

  def solve2(input) do
    #full_input = input ++ [0, Enum.max(input) + 3]

    #input_set = MapSet.new(full_input)

    arrangements = [0 | input]
    |> Enum.sort(:desc)
    |> Enum.reduce(
      Map.new([{Enum.max(input) + 3, 1}]),
      fn adapter, arrangements_from_adapter ->
      new_arrangements = 1..3
      |> Stream.map(&(Map.get(arrangements_from_adapter, adapter + &1, 0)))
      |> Enum.sum()
      Map.put(arrangements_from_adapter, adapter, new_arrangements)
      end

    )

    arrangements[0]

  end


  def example1() do
    """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """
  end
end
