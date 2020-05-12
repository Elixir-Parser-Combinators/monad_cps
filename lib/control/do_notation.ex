defmodule Control.DoNotation do
  @moduledoc """
  This module provides the "monad do ... end" macro.
  """

  @doc """
  This macro provides "do notation" syntax.
  ```
  monad do
    x <- return(23)
    y <- return(99)
    return(x + y)
  end
  ```
  """
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
