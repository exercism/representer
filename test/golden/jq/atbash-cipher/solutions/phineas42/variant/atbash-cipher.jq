("a" | explode | .[0]) as $a |
("0" | explode | .[0]) as $zero |
[range($a; $a + 26)] as $alpha |
($alpha | reverse) as $ahpla |

def map_codes:
  map(. as $in_code |
    if (($in_code >= $zero) and ($in_code < $zero - 10)) then
      $in_code
    else
      $ahpla[($alpha | index($in_code))]
    end
  )
  ;

def decode:
  gsub("[^[:alnum:]]"; "") | ascii_downcase | explode
  | map_codes
  | implode
  ;

def encode:
  decode | [match(".{1,5}"; "g") | .string]  | join(" ")
  ;

if .property=="encode" then
  .input.phrase | encode
else
  .input.phrase | decode
end
