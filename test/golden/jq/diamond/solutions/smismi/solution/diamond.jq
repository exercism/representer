def A: 65;
def tonum: .letter | explode | .[] - A;
def tochar: [. + A] | implode;

tonum as $max
| [range($max + 1), range($max - 1; -1; -1)]
| map(
      "." * ($max - .)                      # left padding
      + tochar                              # letter
      + "." * (. * 2 - 1)                   # middle spaces
      + (if . > 0 then tochar else "" end)  # letter again except for A
      + "." * ($max - .)                    # right padding
     )
| join("\n")
