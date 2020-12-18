defmodule Advent2020.Day07 do
  use Advent2020

  def input() do
    raw_input() |> parse()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [_, bag, raw_content] = Regex.run(~r/(\w+ \w+) bags contain (.*)\./, line)

    content =
      case raw_content do
        "no other bags" ->
          []

        s ->
          s
          |> String.split(", ")
          |> Enum.map(fn l ->
            [_, amount, bag] = Regex.run(~r/(\d+) (\w+ \w+) bag/, l)
            {String.to_integer(amount), bag}
          end)
      end

    {bag, content}
  end

  def solve1(input) do
    bags_that_contain =
      input
      |> Enum.flat_map(fn {bag, content} ->
        content |> Enum.map(fn {_amount, sub_bag} -> {sub_bag, bag} end)
      end)
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        Map.update(acc, k, [v], &(&1 ++ [v]))
      end)

    Stream.unfold(["shiny gold"], fn
      [] -> nil
      [bag | rest] -> {bag, Map.get(bags_that_contain, bag, []) ++ rest}
    end)
    |> MapSet.new()
    |> MapSet.delete("shiny gold")
    |> MapSet.size()
  end

  def solve2(input) do
    bags_contained = Map.new(input)

    (toposort(bags_contained, "shiny gold")
     |> Enum.reduce(%{}, fn bag, bag_sizes ->
       children_size =
         Map.fetch!(bags_contained, bag)
         |> Enum.map(fn {amount, child} -> amount * Map.fetch!(bag_sizes, child) end)
         |> Enum.sum()

       Map.put(bag_sizes, bag, 1 + children_size)
     end)
     |> Map.fetch!("shiny gold")) - 1
  end

  def toposort(bags_contained, bag, visited \\ [])

  def toposort(bags_contained, bag, visited) do
    if MapSet.member?(MapSet.new(visited), bag) do
      visited
    else
      visited_children =
        Map.fetch!(bags_contained, bag)
        |> Enum.map(fn {_amount, b} -> b end)
        |> Enum.reduce(visited, fn child, new_visited ->
          toposort(bags_contained, child, new_visited)
        end)

      visited_children ++ [bag]
    end
  end

  def example do
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
    |> parse()
  end
end
