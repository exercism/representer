defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, & &1.price, &<=/2)
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, fn item -> item.price != nil end)
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      updated_name = String.replace(item.name, old_word, new_word)
      %{item | name: updated_name}
    end)
  end

  def increase_quantity(item, count) do
    updated_quantities =
      Map.new(item.quantity_by_size, fn {size, qty} -> {size, qty + count} end)

    %{item | quantity_by_size: updated_quantities}
  end

  def total_quantity(item) do
    item.quantity_by_size
    |> Map.values()
    |> Enum.sum()
  end
end
