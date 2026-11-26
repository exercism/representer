type house = i32
type street = [5]house

def attribute (a: i32): i32 = 1 << a

def red: i32 = attribute 0
def green: i32 = attribute 1
def ivory: i32 = attribute 2
def yellow: i32 = attribute 3
def blue: i32 = attribute 4

def english: i32 = attribute 5
def spanish: i32 = attribute 6
def ukrainian: i32 = attribute 7
def norwegian: i32 = attribute 8
def japanese: i32 = attribute 9

def dog: i32 = attribute 10
def snail: i32 = attribute 11
def fox: i32 = attribute 12
def horse: i32 = attribute 13
def zebra: i32 = attribute 14

def coffee: i32 = attribute 15
def tea: i32 = attribute 16
def milk: i32 = attribute 17
def oj: i32 = attribute 18
def water: i32 = attribute 19

-- what would Mrs. Grundy say?
def dancing: i32 = attribute 20
def painting: i32 = attribute 21
def reading: i32 = attribute 22
def soccer: i32 = attribute 23
def chess: i32 = attribute 24

def everything: i32 = (1 << 30) - 1

def house_number(h: house): i32 =
  match ((h >> 25) & 0x1f)
  case 1 -> 1
  case 2 -> 2
  case 4 -> 3
  case 8 -> 4
  case 16 -> 5
  case _ -> assert false (-999)

def has (h: house) (a: i32): bool = (h & a) != 0

def feasible_house (h: house): bool =
  has h english == has h red &&
  has h spanish == has h dog &&
  has h green == has h coffee &&
  has h ukrainian == has h tea &&
  has h snail == has h dancing &&
  has h yellow == has h painting &&
  (house_number h == 3) == has h milk &&
  has h norwegian == (house_number h == 1) &&
  has h soccer == has h oj &&
  has h japanese == has h chess &&
  (house_number h == 2) == has h blue &&
  !(house_number h == 1 && has h green) &&
  !(house_number h == 5 && has h ivory) &&
  !(has h reading && has h fox) &&
  !(has h painting && has h horse)

def make_tuple (rs: []i32) (n: i32): []i32 =
  let (xs, _) =
    loop (xs, m) = ([], n)
    for r in rs do
      ([m % r] ++ xs, m / r)
  in xs

def build_house (n: i32): house =
  let ds = make_tuple (replicate 6 5) n
  in foldl (\acc d -> 32 * acc + (1 << d)) 0 ds

def houses_to_try: []house =
  map build_house (0..<5**6) |> filter feasible_house

def houses_by_number (houses: []house): []i32 =
  map (\i -> filter (\h -> house_number h <= i + 1) houses
                    |> length |> i32.i64) (0..<5)

def group_sizes (starts: []i32): []i32 =
  let (xs, _) =
    loop (xs, start) = ([], 0)
    for s in starts do
      (xs ++ [s - start], s)
  in xs

def make_streets: []street =
  let hs = houses_to_try
  let loc = houses_by_number hs
  let groups = group_sizes loc
  let off = [0] ++ loc[:length loc - 1]
  in
    loop streets = []
    for g < i32.product groups do
      let ds = make_tuple groups g |> reverse
      let ss = map (\i -> hs[off[i] + ds[i]]) (0..<5)
      let as = reduce (|) 0 ss
      in if as == everything then streets ++ [ss :> street] else streets

def find (s: street) (a: i32): i64 =
  loop k = (-1)
  for i < 5 do
    if has s[i] a then i else k

def feasible_street (s: street): bool =
  let ig = find s green
  let ii = find s ivory
  let ir = find s reading
  let ifx = find s fox
  let ip = find s painting
  let ih = find s horse
  in ig == ii + 1 && i64.abs (ir - ifx) == 1 && i64.abs (ip - ih) == 1

def nationality (h: house): []u8 =
  match (h >> 5) & 0x1f
  case 1 -> "Englishman"
  case 2 -> "Spaniard"
  case 4 -> "Ukrainian"
  case 8 -> "Norwegian"
  case 16 -> "Japanese"
  case _ -> assert false "space alien"

def solve (a: i32): []u8 =
  let streets = filter feasible_street make_streets
  let street = assert (length streets == 1) streets[0]
  let i = find street a
  in nationality street[i]

def drinks_water: []u8 = solve water

def owns_zebra: []u8 = solve zebra
