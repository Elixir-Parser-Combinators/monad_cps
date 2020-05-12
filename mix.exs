defmodule Control.MixProject do
  use Mix.Project

  def project do
    [
      app: :monad_cps,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/guenni68/monad_cps.git"
    ]
  end

  def application do
    []
  end

  defp deps do
    []
  end

  defp description() do
    """
    This project provides the equivalent of a Monad Typeclass similar to Haskell.
    The main difference though is that the typeclass is not abstract but the continuation monad.

    Any other monad can be expressed using the continuation monad by first defining the *bind* and *return*
    specific to the data type that constitutes the monad and then using 2 provided functions to *wrap* those
    bind and return functions in their continuation monad counterparts.

    Do Notation for convenience is provided via a macro defined in the Control.DoNotation module.

    An example monad for the Maybe type in the README.
    """
  end

  defp package() do
    [
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/guenni68/monad_cps.git"}
    ]
  end
end
