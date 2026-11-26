defmodule BirdCount do

  def today(list) when list == [], do: nil
  def today(list) do
    # Please implement the today/1 function

    hd(list)
  end

  def increment_day_count(list) when list == [], do: [1]

  def increment_day_count(list) do
  [today(list) + 1 | tl(list)]
  end



  def has_day_without_birds?(list) when list == [], do: false
  def has_day_without_birds?(list) do

    if today(list) == 0 do true
    else
      # IO.puts(list)
      # IO.puts("TAIL IS:  ")
      # IO.puts(tl(list))

      has_day_without_birds?(tl(list))
    end
  end
  def total(list) when list == [], do: 0
  def total(list) when length(list) == 1, do: hd(list)
  def total(list) do
    [head | tail] = list
    new_head = head + hd(tail)
    IO.puts(new_head)
    new_list = [new_head | tl(tail)]


    total(new_list)

  end

  def busy_days(list) when list == [], do: 0
  def busy_days([head | tail]) when head >=5 do


      1 + busy_days(tail)

  end
  def busy_days([_head|tail]), do: busy_days(tail)
end
