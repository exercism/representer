defmodule RobotSimulator do
  defstruct direction: nil, position: nil

  defguard is_position(x,y) when is_integer(x) or is_integer(y)

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0,0}) do
    cond do
      not valid_direction?(direction) -> {:error, "invalid direction"}
      not valid_position?(position) -> {:error, "invalid position"}
      true -> %RobotSimulator{direction: direction, position: position}
    end
  end

  defp valid_direction?(direction), do: Enum.member?([:north, :east, :south, :west], direction)

  defp valid_position?({x, y}) when is_position(x,y), do: true
  defp valid_position?(_), do: false

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, <<>>), do: robot
  def simulate(robot, <<instruction::utf8, next::binary>>) do
    case move_robot(instruction, robot) do
      {:error, _} = err -> err
      robot2 -> simulate(robot2, next)
    end
  end

  defp move_robot(?A, %RobotSimulator{ direction: :north, position: {x,y} } = robot), do: %{ robot | position: {x,y+1} }
  defp move_robot(?A, %RobotSimulator{ direction: :south, position: {x,y} } = robot), do: %{ robot | position: {x,y-1} }
  defp move_robot(?A, %RobotSimulator{ direction: :west, position: {x,y} } = robot), do: %{ robot | position: {x-1,y} }
  defp move_robot(?A, %RobotSimulator{ direction: :east, position: {x,y} } = robot), do: %{ robot | position: {x+1,y} }
  defp move_robot(?L, %RobotSimulator{ direction: :north } = robot), do: %{ robot | direction: :west }
  defp move_robot(?L, %RobotSimulator{ direction: :west } = robot), do: %{ robot | direction: :south }
  defp move_robot(?L, %RobotSimulator{ direction: :south} = robot), do: %{ robot | direction: :east }
  defp move_robot(?L, %RobotSimulator{ direction: :east} = robot), do: %{ robot | direction: :north }
  defp move_robot(?R, %RobotSimulator{ direction: :west } = robot), do: %{ robot | direction: :north }
  defp move_robot(?R, %RobotSimulator{ direction: :north} = robot), do: %{ robot | direction: :east }
  defp move_robot(?R, %RobotSimulator{ direction: :east } = robot), do: %{ robot | direction: :south }
  defp move_robot(?R, %RobotSimulator{ direction: :south} = robot), do: %{ robot | direction: :west }
  defp move_robot(_, _), do: {:error, "invalid instruction"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%RobotSimulator{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%RobotSimulator{position: position}), do: position
end
