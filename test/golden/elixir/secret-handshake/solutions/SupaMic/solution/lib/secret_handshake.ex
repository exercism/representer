defmodule SecretHandshake do
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
  
  0b1 = 1
  0b10 = 2
  0b100 = 4
  0b1000 = 8 
  0b10000 = 16
  
  iex(11)> 0b10000
  16
  iex(12)> 0b11100 &&& 0b10011
  16
  iex(13)> 0b11100 &&& 0b11111
  28
  iex(14)> 0b11100            
  28
  iex(15)> 0b11100 &&& 0b00011
  0
  
     code &&& 0b1    == 1 ->  ['wink'] ++ handshake
     code &&& 0b10   == 2 ->  ['double blink'] ++ handshake
     code &&& 0b100  == 4 ->  ['close your eyes'] ++ handshake
     code &&& 0b1000 == 8 ->  ['jump'] ++ handshake
     code &&& 0b10000 == 16 -> Enum.reverse(handshake)
  
  """
  use Bitwise
  
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do 
  
    build_handshake( {code, []}, {0b0, []} )
    |> build_handshake({0b00001, ["wink"]})
    |> build_handshake({0b00010, ["double blink"]})
    |> build_handshake({0b00100, ["close your eyes"]})
    |> build_handshake({0b01000, ["jump"]})
    |> build_handshake({0b10000, :reverse})
    |> case do {_ , result} -> result end
    
    
  end
  
  @spec build_handshake( {integer, [...] }, {integer, [...] } ) :: {integer, [...] }
  defp build_handshake({flag, handshake}, {check, secret}) do
      handshake = case flag &&& check do
         1 -> handshake ++ secret
         2 -> handshake ++ secret 
         4 -> handshake ++ secret
         8 -> handshake ++ secret
         16 -> Enum.reverse(handshake)
         _ -> handshake
      end
      
      {flag, handshake}
  end
    
end
