# Control

This package provides the Mother of all Monads, in other words it provides an Elixir port of the continuation monad.

Other monads can be defined using the continuation monad.

It also provides __do-notation__ via the macro `monad do:` 

## Usage

The code example below shows you how to create a monad instance using *Maybe*.

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

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `monad_cps` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:monad_cps, "~> 0.1.0"}
  ]
end
```

## Version History
* 0.10.0 initial public release

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/control](https://hexdocs.pm/control).

