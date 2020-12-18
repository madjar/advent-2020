defmodule Advent2020 do
  @moduledoc """
  Documentation for `Advent2020`.
  """

  def run() do
    IO.puts("yay")
  end

  @spec __using__(any) :: {:__block__, [{:keep, {any, any}}, ...], [{:def, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote location: :keep do
      def raw_input() do
        [day] =
          Regex.run(
            ~r{Elixir.Advent2020.Day(\d+)},
            to_string(__MODULE__),
            capture: :all_but_first
          )

        File.read!("inputs/#{day}")
      end

      def part1() do
        solve1(input())
      end

      def part2() do
        solve2(input())
      end
    end
  end
end
