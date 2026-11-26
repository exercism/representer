defmodule RationalNumbers do
  import Kernel, except: [abs: 1]
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b1}, {a2, b2}) do
    # r₁ + r₂ = (a₁ * b₂ + a₂ * b₁) / (b₁ * b₂)
    {a1 * b2 - a2 * b1, b1 * b2} |> reduce()
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, b1}, {a2, b2}) do
    add({a1, b1}, {-a2, b2})
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}) do
    {a1 * a2, b1 * b2} |> reduce()
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a1, b1}, {a2, b2}) do
    multiply({a1, b1}, pow_rational({a2, b2}, -1))
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs(x) when is_integer(x) do
    if x < 0, do: -x, else: x
  end

  def abs({a1, a2}) do
    {abs(a1), abs(a2)} |> reduce()
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({a1, b1}, -1) do
    reduce({b1, a1})
  end

  def pow_rational({a1, b1}, n) when n >= 0 do
    {a1 ** n, b1 ** n}
  end

  def pow_rational({a1, b1}, n) do
    {a1, b1} |> pow_rational(-1) |> pow_rational(-n)
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {a, b}) do
    :math.pow(x, a / b)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({a, b}) do
    {a, b} = if b < 0, do: {-a, -b}, else: {a, b}
    d = gcd(abs(a), abs(b))
    if d == 1, do: {a, b}, else: {div(a, d), div(b, d)}
  end

  # internal functions
  defp gcd(a, b) when b > a, do: gcd(b, a)
  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
