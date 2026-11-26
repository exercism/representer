defmodule LanguageList do
  def new() do
    # Please implement the new/0 function
    list=[]
  end

  def add(list, language) do
    # Please implement the add/2 function
    new_lang=language
    list=[new_lang | list]
  end

  def remove(list) do
    # Please implement the remove/1 function
    [head | tail]=list
    list--[head]
  end

  def first(list) do
    # Please implement the first/1 function
    [head | tail]=list
    head
  end

  def count(list) do
    # Please implement the count/1 function
    length(list)
  end

  def functional_list?(list) do
    # Please implement the functional_list?/1 function
    lang="Elixir"
    lang in list
  end
end
