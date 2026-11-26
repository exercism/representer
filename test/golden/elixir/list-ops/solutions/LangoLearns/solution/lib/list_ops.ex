defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  @spec do_count(list, non_neg_integer) :: non_neg_integer
  defp do_count([], count), do: count
  defp do_count([_head|rest], count), do: do_count(rest, count+1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])

  @spec do_reverse(list, list) :: list
  defp do_reverse([], acc), do: acc
  defp do_reverse([head|rest], acc), do: do_reverse(rest, [head|acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, [])

  @spec do_map(list, (any -> any), list) :: list
  defp do_map([], _f, acc), do: acc |> reverse
  defp do_map([head|rest], f, acc), do: do_map(rest, f, [f.(head)|acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, [])

  @spec do_filter(list, (any -> as_boolean(term)), list) :: list
  defp do_filter([], _f, acc), do: acc |> reverse
  defp do_filter([head|rest], f, acc) do
    acc = if f.(head), do: [head|acc], else: acc

    do_filter(rest, f, acc)
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl(l, acc, f), do: do_foldl(l, f, acc)

  @spec do_foldl(list, (any, acc -> acc), acc) :: acc
  defp do_foldl([], _f, acc), do: acc
  defp do_foldl([x|rest], f, acc), do: x |> f.(acc) |> then(&do_foldl(rest, f, &1))

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f), do: l |> reverse |> foldl(acc, f)

  @spec append(list, list) :: list
  def append(a, b), do: a |> reverse |> do_append(b)

  @spec do_append(list, list) :: list
  defp do_append([], b), do: b
  defp do_append([head|rest], b), do: do_append(rest, [head|b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: do_concat(ll, [])

  @spec do_concat([[any]], [any]) :: [any]
  defp do_concat([], acc), do: acc |> reverse
  defp do_concat([[]|rest_lists], acc), do: do_concat(rest_lists, acc)
  defp do_concat([[item|rest_items]|rest_lists], acc) do
    do_concat([rest_items|rest_lists], [item|acc])
  end
end
