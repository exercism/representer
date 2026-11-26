defmodule GottaSnatchEmAll do
  @type card :: String.t()
  @type collection :: MapSet.t(card())

  @spec new_collection(card()) :: collection()
  def new_collection(card), do: MapSet.new([card])

  @spec add_card(card(), collection()) :: {boolean(), collection()}
  def add_card(card, collection) do
    has_card? = MapSet.member?(collection, card)
    new_collection = MapSet.put(collection, card)
    {has_card?, new_collection}
  end

  @spec trade_card(card(), card(), collection()) :: {boolean(), collection()}
  def trade_card(your_card, their_card, collection) do
    member? = &MapSet.member?(collection, &1)
    trade? = not member?.(their_card) or member?.(your_card)
    traded = MapSet.delete(collection, your_card) |> MapSet.put(their_card)
    {trade?, traded}
  end

  @spec remove_duplicates([card()]) :: [card()]
  def remove_duplicates(cards), do: MapSet.new(cards) |> MapSet.to_list() |> Enum.sort()

  @spec extra_cards(collection(), collection()) :: non_neg_integer()
  def extra_cards(your_collection, their_collection) do
    MapSet.difference(your_collection, their_collection) |> MapSet.size()
  end

  @spec boring_cards([collection()]) :: [card()]
  def boring_cards([]), do: []
  def boring_cards([collection | rest]) do
    f = fn c, acc -> MapSet.intersection(c, acc) end
    Enum.reduce(rest, collection, f) |> MapSet.to_list() |> Enum.sort()
  end

  @spec total_cards([collection()]) :: non_neg_integer()
  def total_cards(collections) do
    f = fn c, acc -> MapSet.union(c, acc) end
    Enum.reduce(collections, MapSet.new(), f) |> MapSet.size()
  end

  @spec split_shiny_cards(collection()) :: {[card()], [card()]}
  def split_shiny_cards(collection) do
    {shiny, not_shiny} = MapSet.split_with(collection, & &1 =~ "Shiny")
    sort = & &1 |> MapSet.to_list() |> Enum.sort()
    {sort.(shiny), sort.(not_shiny)}
  end
end
