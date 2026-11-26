defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove([_ | list]) do
    list
  end

  def first([first | _]) do
    first
  end

  def count(list) do
    length(list)
  end

  def functional_list?(["Elixir" | _]), do: true
  def functional_list?([_ | rest]), do: functional_list?(rest)
  def functional_list?([]), do: false
end
