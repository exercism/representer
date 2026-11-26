defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, opts \\ []) do
    max_price = Keyword.get(opts, :maximum_price, 100.00)
    for x <- tops,
      y <- bottoms,
      x.base_color != y.base_color,
      x.price + y.price <= max_price do
        {x, y}
    end
  end
end
