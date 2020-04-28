defmodule Control.DoNotation do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  #  TODO implement nesting
  defmacro monad(do: block) do
    parse_ast(block)
  end

  defp parse_ast({:__block__, _context, lines}) do
    parse_ast(fn x -> x end, lines)
  end

  defp parse_ast(block) do
    block
  end

  defp parse_ast(fun, [line]) do
    fun.(line)
  end

  defp parse_ast(fun, [{:<-, _context, [lhs, rhs]} | remainder]) do
    parse_ast(
      fn next ->
        fun.(
          quote do
            unquote(rhs) ~>> fn unquote(lhs) -> unquote(next) end
          end
        )
      end,
      remainder
    )
  end

  defp parse_ast(fun, [line | remainder]) do
    parse_ast(
      fn next ->
        fun.(
          quote do
            unquote(line) ~>> fn _ -> unquote(next) end
          end
        )
      end,
      remainder
    )
  end
end
