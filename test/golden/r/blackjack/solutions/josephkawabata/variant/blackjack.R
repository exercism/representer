library(dplyr)

parse_card <- function(card) {
  switch(card,
         ace = 11,
         two = 2,
         three = 3,
         four = 4,
         five = 5,
         six = 6,
         seven = 7,
         eight = 8,
         nine = 9,
         ten = 10,
         jack = 10,
         queen = 10,
         king = 10,
         0)
}

first_turn <- function(card1, card2, dealer_card) {
  hand <- parse_card(card1) + parse_card(card2)
  dealer <- parse_card(dealer_card)
  case_when(
    hand == 22 ~ "P",
    hand == 21 && dealer != 10 && dealer != 11 ~ "W",
    (hand == 21) || (dealer == 10 || dealer == 11) ~ "S",
    between(hand, 17, 20) ~ "S",
    between(hand, 12, 16) && !dealer >= 7 ~ "S",
    between(hand, 12, 16) && dealer >= 7 ~ "H",
    hand <= 11 ~ "H"
  )
}