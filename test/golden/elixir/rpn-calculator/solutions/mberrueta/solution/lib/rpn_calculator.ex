# 34 of 46(concepts) - (156 total)

defmodule RPNCalculator do
  def calculate!(stack, operation) do
    operation.(stack)
  end

  def calculate(stack, operation) do
    try do
      r = calculate!(stack, operation)
      {:ok, r}
    rescue
      e in ArgumentError -> {:error, e.message}
      _ -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      r = calculate!(stack, operation)
      {:ok, r}
    rescue
      e in ArgumentError -> {:error, e.message}
      _ -> :error
    end
  end
end
