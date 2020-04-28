defmodule Control.Applicative do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro inject_pure_apply(pure, apply) do
    quote do
      def pure(value) do
        unquote(pure).(value)
      end

      def pa2b <~> pa do
        unquote(apply).(pa2b, pa)
      end

      require Control.Functor

      Control.Functor.inject_fmap(fn a2b, fa -> pure(a2b) <~> fa end)
    end
  end
end
