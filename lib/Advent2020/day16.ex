defmodule Advent2020.Day16 do
  use Advent2020

  def input() do
    [rrules, rmine, rothers] =
      raw_input()
      |> String.split("\n\n", trim: true)

    rules =
      rrules
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        regex = ~r/([^:]+): (\d+)-(\d+) or (\d+)-(\d+)/
        [_, name, r1, r2, r3, r4] = Regex.run(regex, line)

        %{
          name: name,
          ranges: [
            {String.to_integer(r1), String.to_integer(r2)},
            {String.to_integer(r3), String.to_integer(r4)}
          ]
        }
      end)

    mine =
      rmine
      |> String.split("\n", trim: true)
      |> Enum.at(1)
      |> parse_ticket()

    others =
      rothers
      |> String.split("\n", trim: true)
      |> Stream.drop(1)
      |> Enum.map(&parse_ticket/1)

    %{rules: rules, mine: mine, others: others}
  end

  defp parse_ticket(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def solve1(input) do
    allowed = allowed_values(input.rules)

    input.others
    |> Stream.flat_map(fn x -> x end)
    |> Stream.filter(fn value -> !MapSet.member?(allowed, value) end)
    |> Enum.sum()
  end

  defp allowed_values(rules) do
    rules
    |> Stream.flat_map(fn %{ranges: ranges} -> ranges end)
    |> Stream.flat_map(fn {a, b} -> a..b end)
    |> MapSet.new()
  end

  def solve2(input) do
    allowed = allowed_values(input.rules)

    valid_tickets =
      input.others
      |> Enum.filter(fn ticket ->
        ticket
        |> Enum.all?(fn value -> MapSet.member?(allowed, value) end)
      end)

    all_tickets = [input.mine | valid_tickets]

    field_names =
      all_tickets
      |> List.zip()
      |> Enum.map(fn value_set ->
        possible_field(value_set, compile_rules(input.rules))
      end)
      |> strip_ambiguous()

    Enum.zip(field_names, input.mine)
    |> Enum.filter(fn {name, _} -> String.contains?(name, "departure") end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.reduce(&*/2)
  end

  defp compile_rules(rules) do
    rules
    |> Enum.map(fn rule ->
      set =
        rule.ranges
        |> Stream.flat_map(fn {a, b} -> a..b end)
        |> MapSet.new()

      Map.put(rule, :set, set)
    end)
  end

  defp possible_field(values, rules) do
    rules
    |> Enum.filter(fn rule ->
      values
      |> Tuple.to_list()
      |> Enum.all?(fn v -> MapSet.member?(rule.set, v) end)
    end)
    |> Enum.map(& &1.name)
  end

  defp strip_ambiguous(lists_of_possibilities, already_stripped \\ MapSet.new()) do
    next_to_strip =
      for [only_choice] <- lists_of_possibilities,
          !MapSet.member?(already_stripped, only_choice) do
        only_choice
      end
      |> List.first()

    if next_to_strip do
      IO.inspect(next_to_strip)

      new_list =
        lists_of_possibilities
        |> Enum.map(fn
          [^next_to_strip] -> [next_to_strip]
          possibilities -> possibilities |> List.delete(next_to_strip)
        end)

      strip_ambiguous(
        new_list,
        MapSet.put(already_stripped, next_to_strip)
      )
    else
      lists_of_possibilities
      |> Enum.map(fn [x] -> x end)
    end
  end
end
