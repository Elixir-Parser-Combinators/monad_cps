defmodule ContinuationMonad do
  defmacro __using__(_options) do
    quote do
      import Control.Continuation
      import Control.DoNotation
    end
  end
end
