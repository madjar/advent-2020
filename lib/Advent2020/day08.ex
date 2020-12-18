defmodule Advent2020.Day08 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, instr, val] = Regex.run(~r/(\w+) ([+-]\d+)/, line)
      {String.to_atom(instr), String.to_integer(val)}
    end)
  end

  def step(code, {_acc, i} = registers) do
    instr = Enum.at(code, i)
    step_instr(instr, registers)
  end

  def step_instr({:acc, arg}, {acc, i}), do: {acc + arg, i + 1}
  def step_instr({:jmp, arg}, {acc, i}), do: {acc, i + arg}
  def step_instr({:nop, _}, {acc, i}), do: {acc, i + 1}

  def run(input, initial_i \\ 0) do
    Stream.iterate({0, initial_i}, &step(input, &1))
  end

  @spec find_loop_or_terminate(any) :: any
  def find_loop_or_terminate(code, initial_i \\ 0) do
    program_size = Enum.count(code)

    code
    |> run(initial_i)
    |> Enum.reduce_while(MapSet.new(), fn {acc, i}, seen ->
      cond do
        MapSet.member?(seen, i) ->
          {:halt, {:loop, acc}}

        i >= program_size ->
          {:halt, {:terminated, acc}}

        true ->
          {:cont, MapSet.put(seen, i)}
      end
    end)
  end

  def solve1(input) do
    input
    |> find_loop_or_terminate()
  end

  def solve2(input) do
    good_positions =
      0..(Enum.count(input) - 1)
      |> Enum.filter(fn i ->
        input |> find_loop_or_terminate(i) |> elem(0) == :terminated
      end)
      |> MapSet.new()

    position_to_change =
      input
      |> run()
      |> Stream.map(fn {_acc, i} -> {Enum.at(input, i), i} end)
      |> Enum.find(fn
        {{:jmp, _arg}, i} -> MapSet.member?(good_positions, i + 1)
        {{:nop, arg}, i} -> MapSet.member?(good_positions, i + arg)
        _ -> false
      end)
      |> elem(1)

    new_input =
      List.update_at(input, position_to_change, fn
        {:jmp, arg} -> {:nop, arg}
        {:nop, arg} -> {:jmp, arg}
      end)

    new_input |> find_loop_or_terminate()
  end
end
