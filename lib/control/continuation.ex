defmodule Control.Continuation do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Control.DoNotation
    end
  end

  @cont :continuation

  # Monad implementation
  def return(a) do
    {@cont, fn fun -> fun.(a) end}
  end

  def {@cont, inC} ~>> a2cb do
    cont(fn out -> inC.(fn a -> run_cont(a2cb.(a), out) end) end)
  end

  # Monad implementation, helpers
  def cont(fun) do
    {@cont, fun}
  end

  def run_cont({@cont, inC}, fun) do
    inC.(fun)
  end

  # TODO implement callCC
  
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
  def constant(x) do
    fn _fun -> x end
  end

  def id(x) do
    x
  end
end
