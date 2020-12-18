defmodule Advent2020.Day13 do
  use Advent2020

  def input() do
    [earliest, buses] = raw_input() |> String.split("\n", trim: true)

    {earliest |> String.to_integer(),
     buses
     |> String.split(",", trime: true)
     |> Enum.map(fn
       "x" -> :x
       n -> String.to_integer(n)
     end)}
  end

  def solve1(input) do
    {earliest, buses} = input
    valid_buses = buses |> Enum.filter(&(&1 != :x))

    solution =
      valid_buses
      |> Enum.map(fn bus ->
        ride_number = div(earliest, bus) + 1
        departure_time = ride_number * bus
        %{bus: bus, departure_time: departure_time}
      end)
      |> Enum.min_by(& &1.departure_time)

    solution.bus * (solution.departure_time - earliest)
  end

  def solve2(input) do
    {_, buses} = input

    buses
    |> Enum.with_index()
    |> Enum.filter(fn {bus, _} -> bus != :x end)
    |> Enum.reduce(&merge_requirements/2)
  end

  def merge_requirements({period2, offset2}, {period1, base_timestamp}) do
    # Equations:
    # period2 * q = offset2 + new_timestamp
    # period1 * r = base_timestamp
    # period1 * r' = new_timestamp

    common_period = period1 * period2
    # period_diff = period2 - period1
    # offset_diff = offset2 - offset1

    # number_of_period1_to_wait = div(offset_diff, period_diff)
    # IO.inspect(offset_diff, label: "offset_diff")
    # IO.inspect(period_diff, label: "period diff")
    # new_offset = number_of_period1_to_wait * period1 + offset1

    n =
      0..period2
      |> Enum.find(fn i ->
        timestamp = base_timestamp + i * period1
        # IO.inspect(timestamp)
        # IO.inspect(timestamp, period: "timestamp")
        # IO.inspect(timestamp)
        rem(timestamp + offset2, period2) == 0
      end)

    # |> IO.inspect()

    # |> IO.inspect()

    timestamp = base_timestamp + n * period1
    IO.inspect(timestamp, label: "timestamp")
    m = div(timestamp + offset2, period2)

    if m * period2 != timestamp + offset2 do
      IO.inspect(m, label: "m")
      IO.inspect(period2, label: "period2")
      IO.inspect(offset2, label: "offset2")
      raise "plonk2"
    end

    #    IO.puts("#{m} * #{period2} + ")

    if base_timestamp + n * period1 != timestamp do
      raise "plonk1"
    end

    {common_period, timestamp}
  end

  # def merge_requirements(a, b), do: merge_requirements(b, a)
end
