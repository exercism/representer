.number as $number
| ($number | tostring | length) as $exp
| $number
| tostring
| split("")
| filter(tonumber | pow(.; $exp))
| add
| . == $number