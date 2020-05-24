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
    fn fun -> fun.(a) end
  end

  @doc """
  This is the classic monadic *bind* function. In Haskell this would be
  ```
  Monad a >>= \a -> Monad b
  ```
  """
  def inC ~>> a2cb do
    fn out -> inC.(fn a -> run_cont(a2cb.(a), out) end) end
  end

  @doc """
  Shortcut for ~>>
  """
  def ca >>> cb do
    ca ~>> fn _ -> cb end
  end

  # Monad implementation, helpers
  defp run_cont(inC, fun) do
    inC.(fun)
  end

  @doc """
  allows for early exits.
  """
  def call_cc(fun) do
    fn out -> run_cont(fun.(fn a -> const(out.(a)) end), out) end
  end

  # Applicative implementation
  @doc """
  Any Monad instance is also an instance of Applicative. This function is equivalent to *return*
  """
  def pure(a) do
    return(a)
  end

  @doc """
  applies a function from a -> b that is within the Monad to a Monad of type a and produces a Monad of type b.
  """
  def apa2b <~> apa do
    apa2b ~>> fn a2b -> apa ~>> fn a -> pure(a2b.(a)) end end
  end

  # Functor implementation
  @doc """
  Applies a function of type a -> b to a Functor of type a. Produces a Functor of type b.
  """
  def fmap(a2b, fa) do
    pure(a2b) <~> fa
  end

  # helper functions
  @doc """
  Take a value x and produces a function that ignores its input and produces x.
  """
  def const(x) do
    fn _ -> x end
  end

  @doc """
  Identity function
  """
  def id(x) do
    x
  end

  # injections
  @doc """
  This functions produces a "lift" function, that lifts the monad instances into the continuation monad.
  """
  def make_ic(bind) do
    fn m -> fn fred -> bind.(m, fred) end end
  end

  @doc """
  Produces a function that "executes" the continuation monad.
  """
  def make_run(return) do
    fn m -> run_cont(m, return) end
  end
end
