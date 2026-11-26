# Enhanced Zebra Puzzle solution
def permutations: 
  if length < 2 then .
  else range(0; length) as $i | [.[$i]] + (del(.[$i]) | permutations)
  end;

def abs: if . < 0 then -. else . end;

.property as $property |

# Generate nationality permutations with early constraint
["Englishman", "Spaniard", "Ukrainian", "Norwegian", "Japanese"] | permutations as $nations |
def nation(s): $nations | index(s);

# Constraint 10: Norwegian lives in first house
select(nation("Norwegian") == 0) |

# Generate pet permutations with early constraint  
["dog", "snail", "fox", "horse", "zebra"] | permutations as $pets |
def pet(s): $pets | index(s);

# Constraint 3: Spaniard owns dog
select(nation("Spaniard") == pet("dog")) |

# Generate color permutations with early constraints
["blue", "red", "green", "ivory", "yellow"] | permutations as $colors |
def color(s): $colors | index(s);

# Constraint 6: Green house immediately to the right of ivory house  
select(color("green") == color("ivory") + 1) |

# Constraint 2: Englishman lives in red house
select(nation("Englishman") == color("red")) |

# Constraint 15: Norwegian lives next to blue house
select(nation("Norwegian") - color("blue") | abs == 1) |

# Generate drink permutations with constraints
["coffee", "milk", "orange juice", "tea", "water"] | permutations as $drinks |
def drink(s): $drinks | index(s);

# Constraint 9: Person in middle house drinks milk
select(drink("milk") == 2) |

# Constraint 5: Ukrainian drinks tea  
select(nation("Ukrainian") == drink("tea")) |

# Constraint 4: Person in green house drinks coffee
select(color("green") == drink("coffee")) |

# Generate hobby permutations with constraints (corrected from cigarettes)
["dancing", "painter", "reading", "football", "chess"] | permutations as $hobbies |
def hobby(s): $hobbies | index(s);

# Constraint 7: Snail owner likes to go dancing
select(pet("snail") == hobby("dancing")) |

# Constraint 8: Person in yellow house is a painter  
select(color("yellow") == hobby("painter")) |

# Constraint 11: Person who enjoys reading lives next to person with fox
select(hobby("reading") - pet("fox") | abs != 1) |

# Constraint 12: Painter's house is next to house with horse
select(hobby("painter") - pet("horse") | abs == 1) |

# Constraint 13: Person who plays football drinks orange juice
select(drink("orange juice") == hobby("football")) |

# Constraint 14: Japanese person plays chess
select(nation("Japanese") == hobby("chess")) |

# Return the requested answer
if $property == "drinksWater" then 
  $nations[drink("water")]
elif $property == "ownsZebra" then 
  $nations[pet("zebra")]
else
  "Invalid property"
end
