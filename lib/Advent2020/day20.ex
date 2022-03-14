defmodule Advent2020.Day20 do
  use Advent2020

  def input() do
    raw_input()
    |> parse()
  end

  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn tile ->
      [head | lines] = tile |> String.split("\n", trim: true)
      [id] = Regex.run(~r/\d+/, head)

      %{
        id: String.to_integer(id),
        lines: lines |> Enum.map(&String.graphemes/1)
      }
    end)
  end

  def normalize_border(border) do
    max(border, Enum.reverse(border))
  end

  # Border is always in clockwise reading
  def get_borders(lines) do
    up = List.first(lines)
    down = List.last(lines) |> Enum.reverse()

    left = lines |> Enum.map(&List.first/1) |> Enum.reverse()
    right = lines |> Enum.map(&List.last/1)

    [up, right, down, left]
    |> Enum.map(&normalize_border/1)
  end

  def enrich(tiles) do
    tiles
    |> Enum.map(fn %{id: id, lines: lines} ->
      %{id: id, borders: get_borders(lines)}
    end)
  end

  # def find_one(center, tiles) do
  #   IO.inspect(center)
  #   up_border = Enum.at(center.borders, 0)

  #   tiles
  #   |> Enum.filter(fn t ->
  #     t.borders |> Enum.any?(&(&1 == up_border))
  #   end)
  # end

  def id_by_borders(tiles) do
    tiles
    |> Enum.flat_map(fn x -> x.borders |> Enum.map(fn b -> {b, x.id} end) end)
    |> Enum.group_by(fn x -> x |> elem(0) end, fn x -> x |> elem(1) end)
  end

  def corners(id_by_borders, empty_neighbours_count \\ 2) do
    id_by_borders
    |> Map.values()
    |> Enum.filter(fn l -> length(l) == 1 end)
    |> Enum.map(fn [x] -> x end)
    # For each tile, how many borders have no neighbours
    |> Enum.frequencies()
    # Tiles with 2 empty borders are corners :)
    |> Enum.filter(fn {_, count} -> count == empty_neighbours_count end)
    |> Enum.map(fn x -> elem(x, 0) end)
  end

  def solve1(input) do
    tiles = input |> enrich

    tiles
    |> id_by_borders()
    |> corners()
    |> Enum.reduce(&*/2)
  end

  def solve2(input) do
    tiles = input |> enrich()
    id_by_borders = tiles |> id_by_borders()
    sides = id_by_borders |> corners(1)

    corners = id_by_borders |> corners()

    # XXX
    top_left_corner = nil

    # Damn, I'm going to need orientation information to get the final picture
  end

  def example() do
    """
    Tile 2311:
    ..##.#..#.
    ##..#.....
    #...##..#.
    ####.#...#
    ##.##.###.
    ##...#.###
    .#.#.#..##
    ..#....#..
    ###...#.#.
    ..###..###

    Tile 1951:
    #.##...##.
    #.####...#
    .....#..##
    #...######
    .##.#....#
    .###.#####
    ###.##.##.
    .###....#.
    ..#.#..#.#
    #...##.#..

    Tile 1171:
    ####...##.
    #..##.#..#
    ##.#..#.#.
    .###.####.
    ..###.####
    .##....##.
    .#...####.
    #.##.####.
    ####..#...
    .....##...

    Tile 1427:
    ###.##.#..
    .#..#.##..
    .#.##.#..#
    #.#.#.##.#
    ....#...##
    ...##..##.
    ...#.#####
    .#.####.#.
    ..#..###.#
    ..##.#..#.

    Tile 1489:
    ##.#.#....
    ..##...#..
    .##..##...
    ..#...#...
    #####...#.
    #..#.#.#.#
    ...#.#.#..
    ##.#...##.
    ..##.##.##
    ###.##.#..

    Tile 2473:
    #....####.
    #..#.##...
    #.##..#...
    ######.#.#
    .#...#.#.#
    .#########
    .###.#..#.
    ########.#
    ##...##.#.
    ..###.#.#.

    Tile 2971:
    ..#.#....#
    #...###...
    #.#.###...
    ##.##..#..
    .#####..##
    .#..####.#
    #..#.#..#.
    ..####.###
    ..#.#.###.
    ...#.#.#.#

    Tile 2729:
    ...#.#.#.#
    ####.#....
    ..#.#.....
    ....#..#.#
    .##..##.#.
    .#.####...
    ####.#.#..
    ##.####...
    ##..#.##..
    #.##...##.

    Tile 3079:
    #.#.#####.
    .#..######
    ..#.......
    ######....
    ####.#..#.
    .#...#.##.
    #.#####.##
    ..#.###...
    ..#.......
    ..#.###...
    """
    |> parse
  end
end
