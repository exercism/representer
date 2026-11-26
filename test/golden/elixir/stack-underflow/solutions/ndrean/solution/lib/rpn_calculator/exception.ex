defmodule RPNCalculator.Exception do
  alias RPNCalculator.Exception

  def divide(stack) do
    if length(stack) < 2, do: raise(Exception.StackUnderflowError, "when dividing")
    [t | [h]] = stack
    if t == 0, do: raise(Exception.DivisionByZeroError), else: div(h, t)
  end

  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
    @impl true
    def exception(value) do
      case value do
        [] ->
          %DivisionByZeroError{}

        _ ->
          %DivisionByZeroError{message: value}
      end
    end
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] ->
          %StackUnderflowError{}

        _ ->
          %StackUnderflowError{message: "stack underflow occurred, context: " <> value}
      end
    end
  end
end
