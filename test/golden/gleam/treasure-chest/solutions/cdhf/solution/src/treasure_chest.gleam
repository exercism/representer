// Please define the TreasureChest generic custom type
pub type TreasureChest(a) {
  TreasureChest(password: String, treasure: a)
}

// Please define the UnlockResult generic custom type
pub type UnlockResult(treasure) {
  Unlocked(treasure)
  WrongPassword
}

pub fn get_treasure(
  chest: TreasureChest(treasure),
  password: String,
) -> UnlockResult(treasure) {
  case chest {
    TreasureChest(password: p, treasure: t) if p == password -> Unlocked(t)
    _ -> WrongPassword
  }
}
