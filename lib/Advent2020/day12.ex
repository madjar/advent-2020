defmodule Advent2020.Day12 do
  use Advent2020

  def input() do
    raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {action, value} = String.split_at(line, 1)
      {action, String.to_integer(value)}
    end)
  end

  # (west and north are positive)
  def init_state, do: {0, 0, :east}

  def step({"N", value}, {w, n, dir}), do: {w, n + value, dir}
  def step({"S", value}, {w, n, dir}), do: {w, n - value, dir}
  def step({"E", value}, {w, n, dir}), do: {w - value, n, dir}
  def step({"W", value}, {w, n, dir}), do: {w + value, n, dir}

  def step({"F", value}, {w, n, dir}) do
    string_dir =
      case dir do
        :north -> "N"
        :south -> "S"
        :east -> "E"
        :west -> "W"
      end

    step({string_dir, value}, {w, n, dir})
  end

  def step({"L", 90}, {w, n, dir}) do
    new_dir =
      case dir do
        :north -> :west
        :south -> :east
        :east -> :north
        :west -> :south
      end

    {w, n, new_dir}
  end

  def step({"L", degrees}, state) do
    intermediate_state = step({"L", 90}, state)
    step({"L", degrees - 90}, intermediate_state)
  end

  def step({"R", degrees}, state), do: step({"L", 360 - degrees}, state)

  def manhattan({w, n, _dir}), do: abs(w) + abs(n)

  def solve1(input) do
    input
    |> Enum.reduce(init_state(), &step/2)
    |> manhattan()
  end

  # {ship_west, ship_north, waypoint_west, waypoint_north}
  def init_state2(), do: {0, 0, -10, 1}

  def step2({"N", value}, {sw, sn, ww, wn}), do: {sw, sn, ww, wn + value}
  def step2({"S", value}, {sw, sn, ww, wn}), do: {sw, sn, ww, wn - value}
  def step2({"E", value}, {sw, sn, ww, wn}), do: {sw, sn, ww - value, wn}
  def step2({"W", value}, {sw, sn, ww, wn}), do: {sw, sn, ww + value, wn}

  def step2({"L", 90}, {sw, sn, ww, wn}), do: {sw, sn, wn, -ww}

  def step2({"L", degrees}, state) do
    intermediate_state = step2({"L", 90}, state)
    step2({"L", degrees - 90}, intermediate_state)
  end

  def step2({"R", degrees}, state), do: step2({"L", 360 - degrees}, state)

  def step2({"F", value}, {sw, sn, ww, wn}) do
    {sw + ww * value, sn + wn * value, ww, wn}
  end

  @spec manhattan2({number, number, any, any}) :: number
  def manhattan2({w, n, _, _}), do: abs(w) + abs(n)

  def solve2(input) do
    input
    |> Enum.reduce(init_state2(), &step2/2)
    |> manhattan2()
  end
end
