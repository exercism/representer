-- ASCII whitespace: space, tab, LF, CR, vertical tab, form feed.
let is_space (c: u8) : bool =
  c == 32 || c == 9 || c == 10 || c == 13 || c == 11 || c == 12

let is_lower  (c: u8) : bool = c >= 97 && c <= 122    -- 'a'..'z'
let is_upper  (c: u8) : bool = c >= 65 && c <= 90     -- 'A'..'Z'
let is_letter (c: u8) : bool = is_lower c || is_upper c

let any_u8 (p: u8 -> bool) (xs: []u8) : bool =
  reduce (||) false (map p xs)

let all_u8 (p: u8 -> bool) (xs: []u8) : bool =
  reduce (&&) true (map p xs)

-- Trim only trailing whitespace (for “ends with ?” check).
let rtrim (xs: []u8) : []u8 =
  let n = length xs
  let j = loop j = n while j > 0 && is_space xs[j-1] do j - 1
  in xs[:j]

let is_silence (xs: []u8) : bool =
  all_u8 is_space xs

let is_question (xs: []u8) : bool =
  let t = rtrim xs
  let m = length t
  in m > 0 && t[m-1] == 63  -- '?'

let is_yelling (xs: []u8) : bool =
  let has_letters = any_u8 is_letter xs
  let has_lower   = any_u8 is_lower xs
  in has_letters && not has_lower

let response (input: []u8) : []u8 =
  let silence  = is_silence input
  let question = is_question input
  let yelling  = is_yelling input
  in if silence then
       "Fine. Be that way!"
     else if yelling && question then
       "Calm down, I know what I'm doing!"
     else if yelling then
       "Whoa, chill out!"
     else if question then
       "Sure."
     else
       "Whatever."
 