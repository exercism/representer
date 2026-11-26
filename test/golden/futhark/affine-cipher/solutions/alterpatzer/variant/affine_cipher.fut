def gcd (a: i32) (b: i32): i32 =
  let (u, _) = loop (u, v) = (a, b) while v != 0 do (v, u % v) in u

def inverse (a: i32) (m: i32): i32 =
  let (_, _, ai, _) =
    loop (u, v, x, y) =
      (a, m, 0, 1)
      while u != 0 do
        let q = v / u
        let r = v % u
        in (r, u, y, (x - q * y))
  in ai % m

def clean (phrase: []u8): []u8 =
  phrase
  |> map (\c -> c | 0x20)
  |> filter (\c -> c >= '0' && c <= '9' || c >= 'a' && c <= 'z')

def translate (a: i32) (b: i32) (c: u8): u8 =
  if c < 'a' || c > 'z' then c
  else
    let x = i32.u8 (c - 'a')
    let z = u8.i32 ((a * x + b) % 26)
    in 'a' + z

def code (a: i32) (b: i32) (phrase: []u8): []u8 =
  clean phrase |> map (translate a b)

def group (text: []u8): []u8 =
  loop out = [] for i < length text do
    if i % 5 == 0 || i != 0
    then out ++ [' ', text[i]]
    else out ++ [text[i]]

def encode (a: i32) (b: i32) (phrase: []u8): []u8 =
  let g = gcd a 26
  in assert (g == 1) (code a b phrase |> group)

def decode (a: i32) (b: i32) (phrase: []u8): []u8 =
  let g = gcd a 26
  let ainv = assert (g == 1) (inverse a 26)
  in code ainv (-ainv * b % 26) phrase
