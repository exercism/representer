.phrase
| ascii_downcase

# This works:
# | [. / "" | .[]]
# | map(select(test("[[:alpha:]]")))
# 
# This is simpler:
| [scan("[[:alpha:]]")]

# This works:
# | length as $total
# | reduce {(.[]):1} as $e ({}; . + $e)
# | length == $total
#
# This is simpler:
| length == (unique | length)
