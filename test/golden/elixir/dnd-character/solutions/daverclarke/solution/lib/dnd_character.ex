defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    (score-10)/2 |> floor()
  end

  @spec ability :: pos_integer()
  def ability do
    Stream.repeatedly(fn -> :rand.uniform(6) end)
    |> Enum.take(4)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  @spec character :: t()
  def character do
    char = %DndCharacter{
      strength: ability(),
      dexterity: ability(),
      constitution: ability(),
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability(),
    }

    %DndCharacter{char | hitpoints: 10+modifier(char.constitution)}

  end

end
