def preconditions:
  if .inputBase < 2
    then "input base must be >= 2" | halt_error
    else .
  end |
  if .outputBase < 2
    then "output base must be >= 2" | halt_error
    else .
  end |
  .inputBase as $inputBase |
  if .digits | any((. >= $inputBase) or (. < 0))
    then "all digits must satisfy 0 <= d < input base" | halt_error
    else .
  end
;


def digits_to_number(base):
  reduce (. | reverse | .[]) as $digit (
    {place: 1, sum: 0};
    {place: (.place * base), sum: (.sum + $digit * .place)}) | .sum
;

def number_to_digits(base):
  {number: ., digits: [], done: false} |
  [while(
    .done | not; 
    {
      digits: (.digits + [.number % base]),
      number: (.number / base | floor),
      done: (.number == 0)
    })] | .[-1] | .digits | reverse
;

preconditions |
  . as $input |
  $input.digits |
  digits_to_number($input.inputBase) |
  number_to_digits($input.outputBase) |
  if (.|length) == 0
    then [0]
    else .
  end
