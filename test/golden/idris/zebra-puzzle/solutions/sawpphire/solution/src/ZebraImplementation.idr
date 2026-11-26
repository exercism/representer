module ZebraImplementation

import ZebraData

export                     
Eq Color where
  Blue   == Blue   = True
  Yellow == Yellow = True
  Red    == Red    = True
  Ivory  == Ivory  = True
  Green  == Green  = True
  _      == _      = False

export
Eq Nationality where
  Spaniard   == Spaniard   = True
  Norwegian  == Norwegian  = True
  Englishman == Englishman = True
  Japanese   == Japanese   = True
  Ukrainian  == Ukrainian  = True
  _          == _          = False

export
Eq Pet where
  Dog   == Dog   = True
  Snail == Snail = True
  Zebra == Zebra = True
  Fox   == Fox   = True
  Horse == Horse = True
  _     == _     = False

export
Eq Beverage where
  Tea    == Tea    = True
  Coffee == Coffee = True
  Water  == Water  = True
  Juice  == Juice  = True
  Milk   == Milk   = True
  _      == _      = False

export
Eq Hobby where
  Football == Football = True
  Chess    == Chess    = True
  Painter  == Painter  = True
  Dancing  == Dancing  = True
  Reading  == Reading  = True
  _        == _        = False
  
public export  
Eq Parameter where
  MC c == MC c' = c == c'
  MB b == MB b' = b == b'
  MN n == MN n' = n == n'
  MH h == MH h' = h == h'
  MP p == MP p' = p == p'
  _    == _     = False

export
Eq Habitant where (h ** _) == (h' ** _) = h == h'
