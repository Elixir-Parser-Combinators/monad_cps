defmodule Control.Continuation do
  @moduledoc """

  This module provides the Continuation Monad, in which every other monad can be implemented.

  ```elixir
  defmodule Maybe do
    @moduledoc false

    @nothing :nothing
    @just :just

    use ContinuationMonad

    defmacro __using__(_options) do
      quote do
        import unquote(__MODULE__)
        use ContinuationMonad
      end
    end

    defp _return(x) do
      {@just, x}
    end

    defp _bind(@nothing, _a2mb) do
      @nothing
    end

    defp _bind({@just, a}, a2mb) do
      a2mb.(a)
    end

    def return(x) do
      ic(_return(x))
    end

    def nothing() do
      ic(@nothing)
    end

    # Wrapping / Unwrapping
    defp ic(ma) do
      make_ic(&_bind/2).(ma)
    end

    def run(m) do
      make_run(&_return/1).(m)
    end
  end

  defmodule MaybeClient do

    use Maybe

    def some_fun() do
      monad do
        x <- return("eggs")
        y <- return("bacon")
        return({x, y})
      end
    end

    run(some_fun())

  end
  ```
  """

  @cont :cont

  # Monad implementation
  defp return(a) do
    {@cont, fn fun -> fun.(a) end}
  end

  # TODO
  @doc """

  """
  def {@cont, inC} ~>> a2cb do
    cont(fn out -> inC.(fn a -> run_cont(a2cb.(a), out) end) end)
  end

  # TODO
  @doc """

  """
    def ca >>> cb do
    ca ~>> fn _ -> cb end
  end

  # Monad implementation, helpers
  defp cont(fun) do
    {@cont, fun}
  end

  defp run_cont({@cont, inC}, fun) do
    inC.(fun)
  end

  # TODO
  @doc """
  """
    def call_cc(fun) do
    cont(fn out -> run_cont(fun.(fn a -> cont(const(out.(a))) end), out) end)
  end

  # Applicative implementation
  # TODO
  @doc """

  """
  def pure(a) do
    return(a)
  end

  def apa2b <~> apa do
    apa2b ~>> fn a2b -> apa ~>> fn a -> pure(a2b.(a)) end end
  end

  # Functor implementation
  # TODO
  @doc """

  """
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
  # TODO
  @doc """

  """
    def make_ic(bind) do
    fn m -> cont(fn fred -> bind.(m, fred) end) end
  end

  @doc """

  """
    def make_run(return) do
    fn m -> run_cont(m, return) end
  end
end
