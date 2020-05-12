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
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    This project provides the equivalent of a Monad Typeclass similar to Haskell.
    The main difference though is that the typeclass is not abstract but the continuation monad.

    An example monad for the Maybe type in the README.
    """
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/guenni68/monad_cps.git"}
    ]
  end
end
