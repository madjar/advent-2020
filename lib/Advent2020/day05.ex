defmodule Advent2020.Day05 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
  end

  def get_seat_id(pass) do
    replacements = %{"F" => "0", "B" => "1", "L" => "0", "R" => "1"}

    pass
    |> String.replace(Map.keys(replacements), &Map.get(replacements, &1))
    |> String.to_integer(2)
  end

  def solve1(input) do
    input
    |> Enum.map(&get_seat_id/1)
    |> Enum.max()
  end

  def solve2(input) do
    existing_seats = input |> Enum.map(&get_seat_id/1) |> MapSet.new()

    0..2047
    |> Enum.find(fn seat ->
      !MapSet.member?(existing_seats, seat) and
        MapSet.member?(existing_seats, seat + 1) and
        MapSet.member?(existing_seats, seat - 1)
    end)
  end
end
