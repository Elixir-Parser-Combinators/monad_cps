defmodule Control.Alternative do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro inject_empty_choice(empty, choice) do
    quote do
      def empty() do
        unquote(empty)
      end

      def ap_a2b <|> ap_a do
        unquote(choice).(ap_a2b, ap_a)
      end
    end
  end
end
