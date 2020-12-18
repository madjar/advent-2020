defmodule Advent2020.Day14 do
  use Advent2020

  def input() do
    raw_input() |> parse()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "mask = " <> mask ->
        {:mask, mask}

      line ->
        m = Regex.named_captures(~r{mem\[(?<addr>\d+)\] = (?<value>\d+)}, line)
        {:mem, String.to_integer(m["addr"]), String.to_integer(m["value"])}
    end)
  end

  def compile_mask(mask) do
    # an AND-mask, to only keep things that are not X
    a =
      mask
      |> String.replace("1", "0")
      |> String.replace("X", "1")
      |> String.to_integer(2)

    # an OR-mask, to set some of the zeroed-out values to 1
    o =
      mask
      |> String.replace("X", "0")
      |> String.to_integer(2)

    %{and: a, or: o}
  end

  def apply_mask1(value, mask) do
    use Bitwise
    mask = compile_mask(mask)
    (value &&& mask.and) ||| mask.or
  end

  defmodule State do
    defstruct mask: nil, memory: %{}
  end

  def apply_instr1({:mask, mask}, state) do
    %{state | mask: mask}
  end

  def apply_instr1({:mem, addr, value}, state) do
    put_in(state.memory[addr], apply_mask1(value, state.mask))
  end

  def solve1(input) do
    input
    |> Enum.reduce(%State{}, &apply_instr1/2)
    |> (& &1.memory).()
    |> Map.values()
    |> Enum.sum()
  end

  def apply_mask2(addr, mask) do
    use Bitwise

    override_1_mask =
      mask
      |> String.replace("X", "0")
      |> String.to_integer(2)

    intermediate_addr = addr ||| override_1_mask

    individual_bit_masks =
      Regex.scan(~r/X/, mask, return: :index)
      |> Enum.map(fn [{index, _}] ->
        m =
          (String.duplicate(".", index) <> "X")
          |> String.pad_trailing(36, ".")

        {m |> String.replace("X", "1") |> String.replace(".", "0") |> String.to_integer(2),
         m |> String.replace("X", "0") |> String.replace(".", "1") |> String.to_integer(2)}
      end)

    apply_bit_masks(individual_bit_masks, intermediate_addr)
  end

  def pretty(x), do: Integer.to_string(x, 2)

  def apply_bit_masks([], addr), do: [addr]

  def apply_bit_masks([{one_mask, zero_mask} | rest], addr) do
    use Bitwise

    apply_bit_masks(rest, addr)
    |> Stream.flat_map(fn a ->
      [
        one_mask ||| a,
        zero_mask &&& a
      ]
    end)
  end

  def apply_instr2({:mask, mask}, state) do
    %{state | mask: mask}
  end

  def apply_instr2({:mem, addr, value}, state) do
    apply_mask2(addr, state.mask)
    |> Enum.reduce(state, fn a, s ->
      put_in(s.memory[a], value)
    end)
  end

  def solve2(input) do
    input
    |> Enum.reduce(%State{}, &apply_instr2/2)
    |> (& &1.memory).()
    |> Map.values()
    |> Enum.sum()
  end

  def example1() do
    """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """
  end
end
