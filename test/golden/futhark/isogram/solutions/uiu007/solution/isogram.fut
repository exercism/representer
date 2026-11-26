def char_to_mask (c: u8): u32 =
  if c >= 'a' && c <= 'z' then 1u32 << u32.u8 (c - 'a')
  else if c >= 'A' && c <= 'Z' then 1u32 << u32.u8 (c - 'A')
  else 0u32

def combine (mask1: u32, valid1: bool) (mask2: u32, valid2: bool): (u32, bool) =
  let is_valid = valid1 && valid2 && ((mask1 & mask2) == 0u32)
  let new_mask = mask1 | mask2
  in (new_mask, is_valid)


def is_isogram (phrase: []u8): bool =
  phrase
  |> map (\c -> (char_to_mask c, true))
  |> reduce combine (0u32, true)
  |> (\(_, final_valid) -> final_valid)