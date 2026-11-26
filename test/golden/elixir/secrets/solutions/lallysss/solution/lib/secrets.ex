defmodule Secrets do
  def secret_add(secret) do
    fn(argum) -> argum + secret end
  end

  def secret_subtract(secret), do: &(&1 - secret)

  def secret_multiply(secret), do: &(&1 * secret)

  def secret_divide(secret) do
    fn(argum) -> div(argum, secret) end
  end

      use Bitwise
  def secret_and(secret) do
    fn(argum) -> argum &&& secret end
  end

  def secret_xor(secret), do: &(&1 ^^^ secret)

  def secret_combine(secret_function1, secret_function2) do
    fn(argum) -> secret_function1.(argum) |> secret_function2.() end 
  end
end
