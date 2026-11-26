#[derive(Debug, Clone, Copy)]
pub enum Category {
    Ones = 1,
    Twos = 2,
    Threes = 3,
    Fours = 4,
    Fives = 5,
    Sixes = 6,
    FullHouse,
    FourOfAKind,
    LittleStraight,
    BigStraight,
    Choice,
    Yacht,
}


type Dice = [u8; 5];

pub fn score(mut dice: Dice, category: Category) -> u8 {
    dice.sort();
    let count0 = dice.iter().filter(|&&d| d == dice[0]).count() as u8;
    let count4 = dice.iter().filter(|&&d| d == dice[4]).count() as u8;
    match category {
        Category::Ones
        | Category::Twos
        | Category::Threes
        | Category::Fours
        | Category::Fives
        | Category::Sixes => dice.iter().filter(|&&d| d == category as u8).sum(),
        Category::FullHouse if count0 == 2 && count4 == 3 => dice.iter().sum(),
        Category::FullHouse if count0 == 3 && count4 == 2 => dice.iter().sum(),
        Category::FullHouse => 0,
        Category::FourOfAKind if count0 >= 4 => 4 * dice[0],
        Category::FourOfAKind if count4 == 4 => 4 * dice[4],
        Category::FourOfAKind => 0,
        Category::LittleStraight if dice == [1, 2, 3, 4, 5] => 30,
        Category::LittleStraight => 0,
        Category::BigStraight if dice == [2, 3, 4, 5, 6] => 30,
        Category::BigStraight => 0,
        Category::Choice => dice.iter().sum(),
        Category::Yacht if dice.iter().all(|&d| d == dice[0]) => 50,
        Category::Yacht => 0,
    }
}
