defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  @input2 """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

  @input """
467..114..
..........
..35.1633.
....#.....
617*......
.......58.
..592.....
......755.
..........
.664.598..
"""

  test "part1" do
    input = @input2
    result = part1(input)

    assert result == 4361
  end

  test "part2" do
    input = @input2
    result = part2(input)

    assert result == 467835
  end
end
