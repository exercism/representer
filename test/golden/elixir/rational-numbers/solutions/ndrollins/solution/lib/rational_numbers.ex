defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add(a, b) do
    {a1, a2} = a
    {b1, b2} = b
    x = a1 * b2
    y = b1 * a2
    numer = x + y
    if numer == 0, do: {numer, 1}, else: {numer, a2 * b2}
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, b) do
    {a1, a2} = a
    {b1, b2} = b
    x = a1 * b2
    y = b1 * a2
    numer = x - y
    if numer == 0, do: {numer, 1}, else: {numer, a2 * b2}
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply(a, b) do
    {a1, a2} = a
    {b1, b2} = b
    x = a1 * b1
    y = a2 * b2
    if rem(x, 2) == 0 && rem(y, 2) == 0, do: {x / 2, y / 2}, else: {x, y}
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by(num, den) do
    {a1, a2} = num
    {b2, b1} = den
    x = a1 * b1
    y = a2 * b2
    down_two = fn x, y -> (if rem(x, 2) == 0 && rem(y, 2) == 0, do: {x / 2, y / 2}, else: {x, y}) end
    case y < 0 do
      true -> y = y * -1
              x = x * -1
              down_two.(x, y)
      false ->
              down_two.(x, y)
    end
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs(a) do
    {x, y} = a
    down_two = fn x, y -> (if rem(x, 2) == 0 && rem(y, 2) == 0, do: {x / 2, y / 2}, else: {x, y}) end
    cond do
      x < 0 && y < 0 -> y = y * -1
                        x = x * -1
                        down_two.(x, y)
      x < 0 -> x = x * -1
              down_two.(x, y)
      y < 0 -> y = y * -1
              down_two.(x, y)
      {x, y} -> down_two.(x, y)
    end
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational(a, n) do
    {x, y} = a
    case x < 0 do
      true -> 
        if n < 0 do
          {a, b} = {y ** (-1 * n) * -1, x ** (-1 * n) * -1}
          if a < 0 && b < 0, do: {a * -1, b * -1}, else: {a, b}
        else
          {x ** n, y ** n}
        end
      false -> 
        if n < 0 do
          {y ** (-1 * n), x ** (-1 * n)}
        else 
          {x ** n, y ** n}
        end
    end
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, n) do
    {r, s} = n
    x ** (r / s)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce(a) do
    {x, y} = a
    negative_denom_reducer = fn x, y -> (if y < 0, do: {x * -1, y * -1}, else: {x, y}) end
    cond do
      x == 0 -> 
        {x, 1}

      x != 0 && rem(x, 3) == 0 && rem(y, 3) == 0 ->
        x = x / 3
        y = y / 3
        negative_denom_reducer.(x, y)

      x != 0 && rem(x, 2) == 0 && rem(y, 2) == 0 ->
        x = x / 2
        y = y / 2
        negative_denom_reducer.(x, y)

      x != 0 && rem(x, y) == 0 && rem(y, y) == 0 ->
        x = x / y
        y = y / y
        negative_denom_reducer.(x, y)

      {x, y} ->
        negative_denom_reducer.(x, y)
    end
  end
end
