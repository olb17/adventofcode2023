defmodule AdventOfCode.Day03 do
  def part1(args) do
    {symbols, figures} =
      args
      |> parse_grid()
      |> split_symbol()

    grid = figures |> Enum.map(fn {pos, nb} -> {pos, String.to_integer(nb)} end) |> Map.new()

    # seeds are figures adjacent to a symbol
    {_grid, values} =
      symbols
      |> find_seeds(grid)
      |> Enum.group_by(fn {x, _y} -> x end)
      |> Map.values()
      |> Enum.reduce({grid, []}, fn line, {grid, values} ->
        Enum.reduce(line, {grid, values}, fn {x, y}, {grid, values} ->
          grow_seed({x, y}, {grid, values})
        end)
      end)

    Enum.sum(values)
  end

  defp grow_seed(pos, {grid, values}) when is_map_key(grid, pos) do
    {val, ngrid} = Map.pop(grid, pos)
    {right, nngrid} = grow_dir(pos, ngrid, 1, [])
    {left, nnngrid} = grow_dir(pos, nngrid, -1, [])

    str =
      array_to_int(left) <>
        Integer.to_string(val) <>
        (right |> Enum.reverse() |> array_to_int())

    {nnngrid, [String.to_integer(str) | values]}
  end

  defp grow_seed(_pos, {grid, values}), do: {grid, values}

  defp array_to_int(array) do
    Enum.reduce(array, "", fn n, acc -> Integer.to_string(n) <> acc end)
    |> String.reverse()
  end

  defp grow_dir({x, y}, grid, dir, acc) do
    case Map.pop(grid, {x, y + dir}) do
      {nil, nngrid} ->
        {acc, nngrid}

      {val, ngrid} ->
        grow_dir({x, y + dir}, ngrid, dir, [val | acc])
    end
  end

  @border [{-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}]

  defp find_seeds(symbols, grid) do
    symbols
    |> Enum.flat_map(fn {{x, y}, _char} ->
      @border
      |> Enum.flat_map(fn {dx, dy} ->
        if Map.has_key?(grid, {x + dx, y + dy}) do
          [{x + dx, y + dy}]
        else
          []
        end
      end)
    end)
  end

  defp split_symbol(grid) do
    Enum.split_with(grid, fn {_pos, char} ->
      Regex.match?(~r/[^0-9]/, char)
    end)
  end

  defp parse_grid(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.with_index(fn line, i ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index(fn char, j ->
        {{i, j}, char}
      end)
      |> Enum.filter(fn
        {_pos, "."} -> false
        _ -> true
      end)
    end)
    |> Enum.flat_map(& &1)
  end

  def part2(args) do
    {symbols, figures} =
      args
      |> parse_grid()
      |> split_symbol()

    grid = figures |> Enum.map(fn {pos, nb} -> {pos, String.to_integer(nb)} end) |> Map.new()

    # seeds are figures adjacent to a symbol
    {_grid, values} =
      symbols
      |> find_gear_seeds(grid)
      |> Enum.reduce({grid, []}, fn {pos1, pos2}, {grid, values} ->
        {grid, [val1]} = grow_seed(pos1, {grid, []})

        {grid, [val2]} = grow_seed(pos2, {grid, []})

        {grid, [val1 * val2 | values]}
      end)

    Enum.sum(values)
  end

  @border2 [[{0, -1}], [{-1, -1}, {-1, 0}, {-1, 1}], [{0, 1}], [{1, -1}, {1, 0}, {1, 1}]]

  defp find_gear_seeds(symbols, grid) do
    symbols
    |> Enum.flat_map(fn {{x, y}, _char} ->
      seeds =
        @border2
        |> Enum.map(fn range ->
          range
          |> Enum.flat_map(fn {dx, dy} ->
            if Map.has_key?(grid, {x + dx, y + dy}) do
              [{x + dx, y + dy}]
            else
              []
            end
          end)
        end)
        |> Enum.flat_map(fn
          [] -> []
          [{x, y}, {x, yp}] -> if y + 1 == yp, do: [[{x, y}]], else: [[{x, y}], [{x, yp}]]
          rest -> [rest]
        end)

      case seeds do
        [first, second] -> [{hd(first), hd(second)}]
        _ -> []
      end
    end)
  end
end
