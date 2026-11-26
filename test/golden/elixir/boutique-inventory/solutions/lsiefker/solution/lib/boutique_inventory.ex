defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort(inventory, &(&1[:price] <= &2[:price]))
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &(&1[:price] == nil))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn (x) -> do_update_name(x, old_word, new_word) end)
  end
  defp do_update_name(%{price: price, name: name, quantity_by_size: sizes_map}, old_word, new_word) do
    new_name = String.replace(name, old_word, new_word)
    %{price: price, name: new_name, quantity_by_size: sizes_map}
  end

  def increase_quantity(%{price: price, name: name, quantity_by_size: sizes_map}, count) do
    new_sizes_map = Map.new(sizes_map, fn (x) -> {elem(x, 0), elem(x, 1) + count} end)
    %{price: price, name: name, quantity_by_size: new_sizes_map}
  end

  # defp do_update_name(size_tuple, count) do
  #   {elem(size_tuple, 0), elem(size_tuple, 1) + count}
  # end

  def total_quantity(item) do
    Map.values(item.quantity_by_size)
      |> Enum.reduce(0, fn (x, acc) -> x + acc end)
  end
end
