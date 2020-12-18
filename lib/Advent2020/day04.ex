defmodule Advent2020.Day04 do
  use Advent2020

  def input() do
    raw_input()
    |> parse()
  end

  def parse(raw) do
    raw
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_passport/1)
  end

  def parse_passport(line) do
    line
    |> String.split()
    |> Enum.map(fn item -> String.split(item, ":") end)
    |> Enum.map(fn [field, value] -> {String.to_atom(field), value} end)
    |> Map.new()
  end

  @mandatory_fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]

  def is_valid?(passport) do
    Enum.all?(
      @mandatory_fields,
      fn field -> Map.has_key?(passport, field) end
    )
  end

  def solve1(input) do
    input
    |> Enum.count(&is_valid?/1)
  end

  def four_digit_int_in_range(range, value) do
    Regex.match?(~r/\d{4}/, value) &&
      Enum.member?(range, String.to_integer(value))
  end

  def is_really_valid?(passport) do
    four_digit_int_in_range(1920..2002, passport.byr) &&
      four_digit_int_in_range(2010..2020, passport.iyr) &&
      four_digit_int_in_range(2020..2030, passport.eyr) &&
      is_height_valid?(passport.hgt) &&
      Regex.match?(~r/#[0-9a-f]{6}/, passport.hcl) &&
      Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], passport.ecl) &&
      Regex.match?(~r/^\d{9}$/, passport.pid)
  end

  @height_rules [{"cm", 150..193}, {"in", 59..76}]

  def is_height_valid?(height) do
    @height_rules
    |> Enum.any?(fn {unit, range} ->
      case Regex.run(~r{(\d+)#{unit}}, height) do
        [_, h] -> Enum.member?(range, String.to_integer(h))
        _ -> false
      end
    end)
  end

  def solve2(input) do
    input
    |> Enum.filter(&is_valid?/1)
    |> Enum.count(&is_really_valid?/1)
  end

  def example_invalid() do
    """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """
  end

  def example_valid() do
    """
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """
  end

  def test do
    for p <- parse(example_invalid()) do
      if is_valid?(p) && is_really_valid?(p) do
        throw("#{inspect(p)} is valid but should not be")
      end
    end

    for p <- parse(example_valid()) do
      if !(is_valid?(p) && is_really_valid?(p)) do
        throw("#{inspect(p)} is invalid but should be")
      end
    end
  end
end
