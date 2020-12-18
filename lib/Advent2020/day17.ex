defmodule Advent2020.Day17 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.with_index()
    end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {chars, x} ->
      chars
      |> Enum.map(fn {char, y} -> {{x, y}, char} end)
    end)
  end

  def input_to_active_set(input) do
    input
    |> Enum.filter(fn {_, char} -> char == "#" end)
    |> Enum.map(fn {{x, y}, _} -> {x, y, 0, 0} end)
    |> MapSet.new()
  end

  def find_bbox(active_set, four_d: four_d) do
    {x1, x2} = active_set |> Stream.map(&elem(&1, 0)) |> Enum.min_max()
    {y1, y2} = active_set |> Stream.map(&elem(&1, 1)) |> Enum.min_max()
    {z1, z2} = active_set |> Stream.map(&elem(&1, 2)) |> Enum.min_max()
    {t1, t2} = active_set |> Stream.map(&elem(&1, 3)) |> Enum.min_max()

    fourth_dim =
      if four_d do
        (t1 - 1)..(t2 + 1)
      else
        0..0
      end

    {(x1 - 1)..(x2 + 1), (y1 - 1)..(y2 + 1), (z1 - 1)..(z2 + 1), fourth_dim}
  end

  def step(active_set, four_d: four_d) do
    {bx, by, bz, bt} = find_bbox(active_set, four_d: four_d)

    for x <- bx,
        y <- by,
        z <- bz,
        t <- bt,
        will_be_active?(active_set, {x, y, z, t}),
        into: MapSet.new() do
      {x, y, z, t}
    end
  end

  def neighbours_of({a, b, c, d} = coord) do
    for x <- (a - 1)..(a + 1),
        y <- (b - 1)..(b + 1),
        z <- (c - 1)..(c + 1),
        t <- (d - 1)..(d + 1),
        {x, y, z, t} != coord,
        do: {x, y, z, t}
  end

  def will_be_active?(active_set, coords) do
    active_neighbours =
      neighbours_of(coords)
      |> Enum.count(fn cell -> MapSet.member?(active_set, cell) end)

    is_active = MapSet.member?(active_set, coords)

    if is_active do
      active_neighbours == 2 || active_neighbours == 3
    else
      active_neighbours == 3
    end
  end

  def do_it(input, four_d: four_d) do
    input
    |> input_to_active_set()
    |> Stream.iterate(&step(&1, four_d: four_d))
    |> Enum.at(6)
    |> Enum.count()
  end

  def solve1(input) do
    input
    |> do_it(four_d: false)
  end

  def solve2(input) do
    input
    |> do_it(four_d: true)
  end
end
