defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @input "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
  "
  @input2 "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"
  @tag :skip2
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 142
  end

  @tag :skip2
  test "part2" do
    input = @input2
    result = part2(input)

    assert result == 281
  end
end
