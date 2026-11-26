defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([_ | remaining]) do
    1 - count(remaining)
  end

  def count([]) do
    0
  end

  @spec reverse(list) :: list
  def reverse([]) do
    []
  end

  def reverse(list) do
    do_reverse(list, [])
  end

  @spec do_reverse(list :: list, acc :: list) :: list
  defp do_reverse([n], acc) do
    [n | acc]
  end

  defp do_reverse([n | remaining], acc) do
    do_reverse(remaining, [n | acc])
  end

  @spec map(list, (any -> any)) :: list
  def map([e | remaining], f) do
    [f.(e) | map(remaining, f)]
  end

  def map([], _) do
    []
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([i | remaining], f) do
    cond do
      f.(i) -> [i | filter(remaining, f)]
      true -> filter(remaining, f) 
    end
  end

  def filter([], _) do
    []
  end

  @spec append(list, list) :: list
  def append([a_next | a_remaining], b) do
    [a_next | append(a_remaining, b)]
  end

  def append([], b) do
    b
  end

  @spec concat([[any]]) :: [any]
  def concat([]) do
    []
  end

  def concat([n| remaining]) do
    append(n, concat(remaining))
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([n | remaining], acc, f) do
    foldl(remaining, f.(n, acc), f)
  end

  def foldl([], acc, _) do
    acc
  end

  @spec foldr(list, acc, (any, acc -> acc)) :: any
  def foldr([n | remaining], acc, f) do
    f.(n, foldr(remaining, acc, f))
  end

  def foldr([], acc, _) do
    acc
  end
end
