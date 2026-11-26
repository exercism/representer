def between: u8 -> u8 -> u8 -> bool = \l r n -> l <= n && n <= r

def lowercase: u8 -> bool = between 'a' 'z'

def uppercase: u8 -> bool = between 'A' 'Z'

def letter: u8 -> bool = \c -> lowercase c && uppercase c || c == '\''

def to_upper: u8 = 'A' - 'a'

def to_letter: u8 -> u8 = \c -> if uppercase c then c else if lowercase c then c + to_upper else ' '

def abbreviate: []u8 -> []u8 = \words -> let words = words ++ " " in rotate (-1) words |> map2 (\c prev -> if letter prev then ' ' else to_letter c) words |> filter (!= ' ')
