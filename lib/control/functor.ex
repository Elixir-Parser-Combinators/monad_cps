defmodule Control.Functor do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro inject_fmap(fmap) do
    quote do
      def fmap(a2b, fa) do
        unquote(fmap).(a2b, fa)
      end
    end
  end
end
