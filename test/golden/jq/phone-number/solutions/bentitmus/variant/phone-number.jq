def check_code($type; $idx; $value; $text):
  if .[-$idx:-($idx-1)] == $value then
    "\($type) code cannot start with \($text)" | halt_error
  end;
def check_regex($type; $regex):
  if test($regex) then
    "\($type) not permitted" | halt_error
  end;

.phrase
| check_regex("letters"; "[[:alpha:]]")
| check_regex("punctuations"; "[@:!]")
| [scan("\\d")]
| add
| if length <= 10 then
    "must not be fewer than 10 digits" | halt_error
  elif length > 11 then
    "must not be greater than 11 digits" | halt_error
  elif (length == 11) and (.[:1] != "1") then
    "11 digits must start with 1" | halt_error
  end
| check_code("area"; 10; "0"; "zero")
| check_code("area"; 10; "1"; "one")
| check_code("exchange"; 7; "0"; "zero")
| check_code("exchange"; 7; "1"; "one")
| .[-10:]
