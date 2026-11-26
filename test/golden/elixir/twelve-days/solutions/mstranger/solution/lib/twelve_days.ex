defmodule TwelveDays do
  @gifts %{
    1  => {:first,    :a,      "Partridge"},
    2  => {:second,   :two,    "Turtle Doves"},
    3  => {:third,    :three,  "French Hens"},
    4  => {:fourth,   :four,   "Calling Birds"},
    5  => {:fifth,    :five,   "Gold Rings"},
    6  => {:sixth,    :six,    "Geese-a-Laying"},
    7  => {:seventh,  :seven,  "Swans-a-Swimming"},
    8  => {:eighth,   :eight,  "Maids-a-Milking"},
    9  => {:ninth,    :nine,   "Ladies Dancing"},
    10 => {:tenth,    :ten,    "Lords-a-Leaping"},
    11 => {:eleventh, :eleven, "Pipers Piping"},
    12 => {:twelfth,  :twelve, "Drummers Drumming"}
  }

  defp template(day, count, gift) do
    "On the #{day} day of Christmas my true love gave to me: #{count} #{gift}"
  end

  defp previous(1) do
    "and a Partridge in a Pear Tree."
  end

  defp previous(day) do
    {_, count, gift} = Map.get(@gifts, day)
    "#{count} #{gift}, #{previous(day-1)}"
  end

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(1) do
    {day, count, gift} = Map.get(@gifts, 1)
    "#{template(day, count, gift)} in a Pear Tree."
  end

  def verse(number) do
    {day, count, gift} = Map.get(@gifts, number)
    "#{template(day, count, gift)}, #{previous(number-1)}"
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse..ending_verse
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end

end
