include std/math.e
include std/sequence.e

constant MAPPINGS = {
  "wink",
  "double blink",
  "close your eyes",
  "jump"
}

public function commands(integer number)
  sequence result = {}
  for i = 0 to 4 do
    if and_bits(shift_bits(1, -i), number) then
      if i = 4 then
        result = reverse(result)
      else
        result = append(result, MAPPINGS[i + 1])
      end if
    end if
  end for
  return result
end function
