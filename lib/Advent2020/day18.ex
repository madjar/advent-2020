defmodule Advent2020.Day18 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(&lex/1)
  end

  def lex(line) do
    line
    |> String.replace(" ", "")
    |> String.graphemes()
  end

  def parse(input) do
    {result, []} = parse_it(input)
    result
  end

  def parse_it(input) do
    {expr1, r1} = parse_expr(input)
    parse_right(r1, expr1)
  end

  def parse_right([symbol | r1], left) when symbol == "+" or symbol == "*" do
    {right, r2} = parse_expr(r1)

    expr = {
      case symbol do
        "+" -> :plus
        "*" -> :times
      end,
      left,
      right
    }

    parse_right(r2, expr)
  end

  def parse_right(rest, left) do
    {left, rest}
  end

  def parse_expr(input) do
    parse_digit(input) || parse_paren(input)
  end

  def parse_digit([digit | rest]) do
    case Integer.parse(digit) do
      {n, ""} -> {n, rest}
      :error -> nil
    end
  end

  def parse_paren(["(" | rest]) do
    {expr, r1} = parse_it(rest)
    [")" | r2] = r1
    {expr, r2}
  end

  def compute(i) when is_integer(i), do: i

  def compute({op, left, right}) do
    f =
      case op do
        :plus -> &+/2
        :times -> &*/2
      end

    f.(compute(left), compute(right))
  end

  def solve1(input) do
    input
    |> Enum.map(fn line -> line |> parse |> compute end)
    |> Enum.sum()
  end

  defmodule Parse2 do
    def parse(input) do
      {result, []} = expression(input)
      result
    end

    def expression(input) do
      {left, r1} = additive_expression(input)

      case r1 do
        ["*" | r2] ->
          {right, r3} = expression(r2)
          {{:times, left, right}, r3}

        _ ->
          {left, r1}
      end
    end

    def additive_expression(input) do
      {left, r1} = primary(input)

      case r1 do
        ["+" | r2] ->
          {right, r3} = additive_expression(r2)
          {{:plus, left, right}, r3}

        _ ->
          {left, r1}
      end
    end

    def primary(input) do
      parse_digit(input) || parse_paren(input)
    end

    def parse_digit([digit | rest]) do
      case Integer.parse(digit) do
        {n, ""} -> {n, rest}
        :error -> nil
      end
    end

    def parse_paren(["(" | rest]) do
      {expr, r1} = expression(rest)
      [")" | r2] = r1
      {expr, r2}
    end
  end

  def solve2(input) do
    input
    |> Enum.map(fn line -> line |> Parse2.parse() |> compute end)
    |> Enum.sum()
  end
end
