defmodule Advent2020.Day11 do
  use Advent2020

  def input() do
    raw_input() |> parse()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.graphemes/1)
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, j} ->
      row
      |> Stream.with_index()
      |> Stream.map(fn {cell, i} ->
        {{i, j},
         case cell do
           "L" -> :seat
           "." -> :floor
         end}
      end)
    end)
    |> Map.new()
  end

  def pretty(layout) do
    x = layout |> Enum.map(fn {{i, _}, _} -> i end) |> Enum.max()
    y = layout |> Enum.map(fn {{_, j}, _} -> j end) |> Enum.max()

    0..(x - 1)
    |> Enum.map(fn i ->
      0..(y - 1)
      |> Enum.map(fn j ->
        case Map.fetch!(layout, {i, j}) do
          :floor -> "."
          :seat -> "L"
          :occupied -> "#"
        end
      end)
      |> List.to_string()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  @neighbours [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def neighbours_of(layout, {x, y}) do
    @neighbours
    |> Stream.map(fn {i, j} ->
      coord = {x + i, y + j}
      Map.get(layout, coord)
    end)
    |> Stream.filter(&(&1 != nil))
  end

  def step(layout, occupied_threshold, neighbours) do
    layout
    |> Enum.map(fn
      {coord, :floor} ->
        {coord, :floor}

      {coord, value} ->
        occupied_neightbours =
          neighbours.(layout, coord)
          |> Enum.count(fn cell -> cell == :occupied end)

        new_value =
          case {value, occupied_neightbours} do
            {:seat, 0} -> :occupied
            {:occupied, n} when n < occupied_threshold -> :occupied
            _ -> :seat
          end

        {coord, new_value}
    end)
    |> Map.new()
  end

  def step1(layout), do: step(layout, 4, &neighbours_of/2)

  def find_stable(init, step) do
    [stable, _] =
      init
      |> Stream.iterate(step)
      |> Stream.chunk_every(2, 1)
      |> Enum.find(fn [a, b] -> a == b end)

    stable
  end

  def count_occupied(layout) do
    layout
    |> Enum.count(fn {_, value} -> value == :occupied end)
  end

  @spec solve1(any) :: non_neg_integer
  def solve1(input) do
    input
    |> find_stable(&step1/1)
    |> count_occupied()
  end

  def look(from, {x, y}) do
    from
    |> Stream.iterate(fn {i, j} ->
      {x + i, y + j}
    end)
    |> Stream.drop(1)
  end

  def visible_neighbours_of(layout, coord) do
    @neighbours
    |> Stream.map(fn direction ->
      look(coord, direction)
      |> Stream.map(&Map.get(layout, &1))
      |> Enum.find(&(&1 != :floor))
    end)
    |> Stream.filter(&(&1 != nil))
  end

  def step2(layout), do: step(layout, 5, &visible_neighbours_of/2)

  def solve2(input) do
    input
    |> find_stable(&step2/1)
    |> count_occupied()
  end

  def example() do
    """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end
end
