defmodule SecretHandshake do
  use Bitwise

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code), do: command_r(code, [])

  @spec command_r(code :: integer, commands :: list(String.t())) :: list(String.t())
  defp command_r(code, commands) when code == 0,
    do: commands

  defp command_r(code, commands) when (1 &&& code) == 1,
    do: command_r(code - 1, commands ++ ["wink"])

  defp command_r(code, commands) when (2 &&& code) == 2,
    do: command_r(code - 2, commands ++ ["double blink"])

  defp command_r(code, commands) when (4 &&& code) == 4,
    do: command_r(code - 4, commands ++ ["close your eyes"])

  defp command_r(code, commands) when (8 &&& code) == 8,
    do: command_r(code - 8, commands ++ ["jump"])

  defp command_r(code, commands) when (16 &&& code) == 16,
    do: Enum.reverse(commands)

  defp command_r(_code, _comands), do: []
end
