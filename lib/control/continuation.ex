defmodule Control.Continuation do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Control.DoNotation
    end
  end

  @cont :cont

  # Monad implementation
  def return(a) do
    {@cont, fn fun -> fun.(a) end}
  end

  def {@cont, inC} ~>> a2cb do
    cont(fn out -> inC.(fn a -> run_cont(a2cb.(a), out) end) end)
  end

  # Monad implementation, helpers
  defp cont(fun) do
    {@cont, fun}
  end

  defp run_cont({@cont, inC}, fun) do
    inC.(fun)
  end

  def call_cc(fun) do
    cont(fn out -> run_cont(fun.(fn a -> cont(const(out.(a))) end), out) end)
  end

  # Applicative implementation
  def pure(a) do
    return(a)
  end

  def apa2b <~> apa do
    apa2b ~>> fn a2b -> apa ~>> fn a -> pure(a2b.(a)) end end
  end

  # Functor implementation
  def fmap(a2b, fa) do
    pure(a2b) <~> fa
  end

  # helper functions
  def const(x) do
    fn _ -> x end
  end

  def id(x) do
    x
  end

  # injections
  def make_ic(bind) do
    fn m -> cont(fn fred -> bind.(m, fred) end) end
  end

  def make_run(return) do
    fn m -> run_cont(m, return) end
  end
end
