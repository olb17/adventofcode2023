defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
    |> Enum.filter(fn {_i, game} ->
      Enum.all?(game, fn draw ->
        12 >= Map.get(draw, "red", 0) &&
          13 >= Map.get(draw, "green", 0) &&
          14 >= Map.get(draw, "blue", 0)
      end)
    end)
    |> Enum.map(fn {i, _game} -> i end)
    |> Enum.sum()
  end

  defp parse_game(line) do
    ["Game " <> i, draws] =
      line
      |> String.split(":")

    {String.to_integer(i), parse_draws(draws)}
  end

  defp parse_draws(draws) do
    draws
    |> String.split(";", trim: true)
    |> Enum.map(&parse_draw/1)
  end

  defp parse_draw(draw) do
    draw
    |> String.split(",")
    |> Enum.map(&parse_color/1)
    |> Map.new()
  end

  defp parse_color(color) do
    [nb, c] =
      color
      |> String.split(" ", trim: true)

    {c, String.to_integer(nb)}
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
    |> Enum.map(&find_min/1)
    |> Enum.map(fn %{"red" => red, "blue" => blue, "green" => green} -> green * blue * red end)
    |> Enum.sum()
  end

  defp find_min({_i, colors}) do
    Enum.reduce(
      colors,
      %{"red" => 0, "blue" => 0, "green" => 0},
      fn color,
         %{
           "red" => min_red,
           "blue" => min_blue,
           "green" => min_green
         } ->
        %{
          "red" => Enum.max([Map.get(color, "red", 0), min_red]),
          "blue" => Enum.max([Map.get(color, "blue", 0), min_blue]),
          "green" => Enum.max([Map.get(color, "green", 0), min_green])
        }
      end
    )
  end
end
