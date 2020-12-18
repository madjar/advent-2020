defmodule Advent2020.Day15 do
  use Advent2020

  def input() do
    "0,8,15,2,12,1,4"
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defmodule State do
    defstruct turn: 0, next_to_speak: nil, last_time_spoken: %{}

    def from_list([h | rest]) do
      Enum.reduce(
        rest,
        init(h),
        &inject/2
      )
    end

    def init(value) do
      %State{next_to_speak: value}
    end

    def inject(value, state) do
      intermediate_state = %{state | turn: state.turn + 1, next_to_speak: value}

      put_in(
        intermediate_state.last_time_spoken[state.next_to_speak],
        state.turn
      )
    end

    def next(state) do
      if rem(state.turn, 1_000_000) == 0 do
        IO.write(".")
      end

      next_to_speak =
        case Map.get(state.last_time_spoken, state.next_to_speak) do
          nil -> 0
          t -> state.turn - t
        end

      int = %{state | turn: state.turn + 1, next_to_speak: next_to_speak}
      {next_to_speak, put_in(int.last_time_spoken[state.next_to_speak], state.turn)}
    end
  end

  def play(input) do
    input
    |> State.from_list()
    |> Stream.unfold(&State.next/1)
    |> (&Stream.concat(input, &1)).()
  end

  def solve1(input) do
    input
    |> play()
    |> Enum.at(2019)
  end

  def solve2(input) do
    input
    |> play()
    |> Enum.at(30_000_000 - 1)
  end
end
