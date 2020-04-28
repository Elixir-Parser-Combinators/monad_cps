defmodule Control.Monad do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      import Control.DoNotation
    end
  end

  defmacro inject_bind_return(bind, return) do
    quote do
      def ma ~>> a2mb do
        unquote(bind).(ma, a2mb)
      end

      def return(value) do
        unquote(return).(value)
      end

      require Control.Applicative

      Control.Applicative.inject_pure_apply(
        &return/1,
        fn pa2b, pa -> pa2b ~>> fn a2b -> pa ~>> fn a -> pure(a2b.(a)) end end end
      )
    end
  end
end
