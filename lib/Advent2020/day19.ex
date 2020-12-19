defmodule Advent2020.Day19 do
  use Advent2020

  def input() do
    raw_input()
    |> parse()
  end

  def parse(input) do
    [rrules, rmessages] = input |> String.split("\n\n")

    rules =
      rrules
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)
      |> Map.new()

    messages =
      rmessages
      |> String.split("\n", trim: true)

    %{rules: rules, messages: messages}
  end

  def parse_rule(line) do
    [label, body] = line |> String.split(": ")

    rule =
      if String.starts_with?(body, "\"") do
        {:literal, String.trim(body, "\"")}
      else
        alternatives =
          body
          |> String.split(" | ")
          |> Enum.map(fn sub_rules ->
            sub_rules
            |> String.split()
            |> Enum.map(&String.to_integer/1)
          end)
          |> Enum.map(fn sub_rules -> {:sub_rules, sub_rules} end)

        case alternatives do
          [one] -> one
          many -> {:alternative, many}
        end
      end

    {String.to_integer(label), rule}
  end

  def match_rule_0(message, input) do
    match(message, input, 0)
    |> Enum.any?(&(&1 == []))
  end

  def match(message, input, rule) when is_binary(message) do
    match(String.graphemes(message), input, rule)
  end

  def match(message, input, rule) when is_integer(rule) do
    match(message, input, Map.fetch!(input, rule))
  end

  def match(message, _input, {:literal, l}) do
    case message do
      [^l | rest] ->
        [rest]

      _ ->
        []
    end
  end

  def match(message, input, {:alternative, [r1, r2]}) do
    Stream.concat(match(message, input, r1), match(message, input, r2))
  end

  def match(message, input, {:sub_rules, [r1]}) do
    match(message, input, r1)
  end

  def match(message, input, {:sub_rules, [r1 | other_rules]}) do
    match(message, input, r1)
    |> Stream.flat_map(fn r ->
      match(r, input, {:sub_rules, other_rules})
    end)
  end

  def solve1(input) do
    input.messages
    |> Enum.count(fn m -> match_rule_0(m, input.rules) end)
  end

  def output(input, rule) when is_integer(rule) do
    output(input, Map.fetch!(input, rule))
  end

  def output(_input, {:literal, l}) do
    [[l]]
  end

  def output(input, {:alternative, rules}) do
    rules
    |> Stream.flat_map(fn r -> output(input, r) end)
  end

  def output(input, {:sub_rules, [r]}) do
    output(input, r)
  end

  def output(input, {:sub_rules, [r1 | other_rules]}) do
    output(input, r1)
    |> Stream.flat_map(fn o1 ->
      output(input, {:sub_rules, other_rules})
      |> Stream.map(fn o2 -> o1 ++ o2 end)
    end)
  end

  def new_rules() do
    """
    8: 42 | 42 8
    11: 42 31 | 42 11 31

    """
    |> parse
    |> (& &1.rules).()

    # 42 = 8 char, 128 possibilities
    # 31 = 8 char, 128 possibilities
  end

  def solve2(input) do
    # NOTE: misleading instructions, handling the general case was fine
    rules = Map.merge(input.rules, new_rules())

    input.messages
    |> Enum.count(fn m -> match_rule_0(m, rules) end)
  end

  def example() do
    """
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    aaaabb
    """
  end
end
