defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      figures =
        String.replace(line, ~r"[a-z]", "")
        |> String.split("", trim: true)

      case figures do
        [f] -> f <> f
        [h | tail] -> h <> List.last(tail)
      end
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      figures =
        line
        |> replace_string_figures()
        |> String.replace(~r"[a-z]", "")
        |> String.split("", trim: true)

      case figures do
        [f] -> f <> f
        [h | tail] -> h <> List.last(tail)
      end
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  @figures [
    {"one", "1"},
    {"two", "2"},
    {"three", "3"},
    {"four", "4"},
    {"five", "5"},
    {"six", "6"},
    {"seven", "7"},
    {"eight", "8"},
    {"nine", "9"}
  ]

  defp replace_string_figures("") do
    ""
  end

  defp replace_string_figures(line) do
    {header, tail} =
      @figures
      |> Enum.reduce_while(line, fn {str, i}, line ->
        if String.starts_with?(line, str) do
          {_header, tail} = String.split_at(line, 1)
          {:halt, i <> tail}
        else
          {:cont, line}
        end
      end)
      |> String.split_at(1)

    header <> replace_string_figures(tail)
  end
end
