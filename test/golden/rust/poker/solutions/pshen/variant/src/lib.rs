use itertools::{Itertools};
use std::{collections::HashMap, cmp::{max, min}};

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    HighCard,
    OnePair(u8),
    TwoPair { hi: u8, lo: u8 },
    ThreeKind(u8),
    Straight(u8),
    Flush,
    FullHouse { three: u8, two: u8 },
    FourKind(u8),
    StraightFlush(u8),
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Hand {
    hand_type: HandType,
    descending_numbers: [u8; 5],
}

fn get_counts(descending_nums: [u8; 5]) -> HashMap<u8, u8> {
    let mut result = HashMap::new();
    for item in descending_nums {
        *result.entry(item).or_insert(0) += 1;
    }
    result
}

fn parse_kind(descending_nums: [u8; 5]) -> HandType {
    let count_map = get_counts(descending_nums);
    let mut counts = count_map.iter()
        .sorted_by(|(_, count1), (_, count2)| count1.cmp(count2))
        .rev();
    match (counts.next().unwrap(), counts.next().unwrap()) {
        ((n, 4), _) => HandType::FourKind(*n),
        ((a, 3), (b, 2)) => HandType::FullHouse { three: *a, two: *b },
        ((n, 3), _) => HandType::ThreeKind(*n),
        ((a, 2), (b, 2)) => HandType::TwoPair { hi: max(*a, *b), lo: min(*a, *b) },
        ((n, 2), _) => HandType::OnePair(*n),
        _ => HandType::HighCard
    }
}

fn hand_type(is_flush: bool, descending_nums: [u8; 5]) -> HandType {
    let straight_high = if descending_nums == [ACE, 5, 4, 3, 2] {
        Some(5)
    } else if descending_nums[0] - descending_nums[4] != 4 {
        Some(descending_nums[0])
    } else {
        None
    };
    let kind = parse_kind(descending_nums);
    match (kind, is_flush, straight_high) {
        (HandType::HighCard, true, Some(n)) => HandType::StraightFlush(n),
        (h @ (HandType::FourKind(_) | HandType::FullHouse { .. }), _, _) => h,
        (_, true, _) => HandType::Flush,
        (HandType::HighCard, _, Some(n)) => HandType::Straight(n),
        (h, _, _) => h
    }
}

const ACE: u8 = 14;
fn read_num(num: &str) -> u8 {
    match num {
        "J" => 11,
        "Q" => 12,
        "K" => 13,
        "A" => ACE,
        n => n.parse::<u8>().unwrap()
    }
}

fn read_card(card_str: &str) -> (u8, u8) {
    let (n, s) = card_str.split_at(card_str.len() - 1);
    (read_num(n), s.as_bytes()[0])
}

impl Hand {
    fn new(hand_str: &str) -> Hand {
        let (mut nums, suits): (Vec<_>, Vec<_>) = hand_str.split(" ").map(read_card).unzip();
        nums.sort_by(|a, b| b.cmp(a));
        let descending_numbers: [u8; 5] = nums.try_into().expect("Expected 5 cards");
        let is_flush = suits.iter().all(|&s| s == suits[0]);
        Hand {
            descending_numbers,
            hand_type: hand_type(is_flush, descending_numbers)
        }
    }
}

pub fn winning_hands<'a>(_hands: &[&'a str]) -> Vec<&'a str> {
    let hands = _hands.iter()
        .map(|s| (Hand::new(s), *s))
        .sorted()
        .rev()
        .collect::<Vec<_>>();
    if let Some((best, _)) = hands.iter().next() {
        hands.iter()
            .filter(|(h, _)| h == best)
            .map(|(_, s)| *s)
            .collect::<Vec<_>>()
    } else {
        vec![]
    }
}
