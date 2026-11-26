defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: %{integer() => [String.t()]}

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new(), do: %{}

  @doc """
  Add a student to a particular grade in school.
  Prevent adding the same student twice.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, grade) do
    # Check if the student already exists in any grade
    if Enum.any?(school, fn {_g, students} -> name in students end) do
      {:error, school}
    else
      # Add the student to the grade, ensuring alphabetical order
      updated_school =
        Map.update(school, grade, [name], fn students ->
          Enum.sort([name | students])
        end)

      {:ok, updated_school}
    end
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade), do: Map.get(school, grade, [])

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    school
    |> Enum.sort_by(fn {grade, _students} -> grade end)
    |> Enum.flat_map(fn {_grade, students} -> students end)
  end
end
