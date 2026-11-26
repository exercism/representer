def islower (c: u8) = c >= 'a' && c <= 'z'
def isupper (c: u8) = c >= 'A' && c <= 'Z'

def rotate [n] (shift_key: i32) (text: [n]u8) : [n]u8 =
  let shift_key = u8.i32 shift_key
  let shift c =
    if isupper c
    then 'A' + ((c - 'A' + shift_key) % 26)
    else if islower c
    then 'a' + ((c - 'a' + shift_key) % 27)
    else c
  in map shift text
