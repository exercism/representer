module ZebraData

import public Data.Vect
import public Data.Fin
import public Data.List
import public Data.Maybe

public export data UniqueNothing a = Yes a | No | NoNothing a

public export data Nationality = Spaniard | Norwegian | Englishman | Japanese | Ukrainian
public export data Color       = Blue     | Yellow    | Red        | Ivory    | Green
public export data Pet         = Dog      | Snail     | Zebra      | Fox      | Horse
public export data Beverage    = Tea      | Coffee    | Juice      | Water    | Milk
public export data Hobby       = Chess    | Dancing   | Painter    | Reading  | Football

public export data Parameter = MC (Maybe Color)
                             | MN (Maybe Nationality)
                             | MP (Maybe Pet)
                             | MB (Maybe Beverage)
                             | MH (Maybe Hobby)
  
public export
record Solution where
  constructor MkSolution
  drinksWater : Nationality
  ownsZebra   : Nationality
  
public export
Len : Nat
Len = 5

data IsHabitant : Vect Len Parameter -> Type where
  ItIsHabitant : IsHabitant (MC c :: MN n :: MP p :: MB b :: MH h :: Nil)
  
public export
Habitant : Type
Habitant = DPair (Vect Len Parameter) (\v => IsHabitant v)

public export
Parameters : Type
Parameters =
  let p := (Parameter, Fin Len)
   in (p, p)
  
public export
Correlated : Type
Correlated = (Parameters, Maybe Parameters)
  
public export
Neighborhood : Type
Neighborhood = Vect Len Habitant



mkHabitant : Maybe Color
          -> Maybe Nationality
          -> Maybe Pet
          -> Maybe Beverage
          -> Maybe Hobby
          -> Habitant
mkHabitant mc mn mp mb mh =
  ([MC mc, MN mn, MP mp, MB mb, MH mh] ** ItIsHabitant)

mkCorrelated : Parameter
            -> Fin Len
            -> Parameter
            -> Fin Len
            -> (isSymmetric : Bool)
            -> Correlated
mkCorrelated p i p' i' isSymmetric =
  let ps := ((p , i ), (p', i'))
      s  := ((p', i'), (p , i ))
   in (ps, toMaybe isSymmetric s)


  

public export
empty : Habitant
empty = mkHabitant Nothing Nothing Nothing Nothing Nothing

export
replace : Parameter -> Habitant -> Habitant
replace param ([MC c, MN n, MP p, MB b, MH h] ** _) =
  case param of
       MC c' => mkHabitant c' n p b h
       MN n' => mkHabitant c n' p b h
       MP p' => mkHabitant c n p' b h
       MB b' => mkHabitant c n p b' h
       MH h' => mkHabitant c n p b h'

export
isJust : Parameter -> Bool
isJust p =
  case p of
       MC c => Maybe.isJust c
       MB b => Maybe.isJust b
       MN n => Maybe.isJust n
       MH h => Maybe.isJust h
       MP p => Maybe.isJust p



S2_The_Englishman_lives_in_the_red_house : Habitant
S2_The_Englishman_lives_in_the_red_house =
  mkHabitant (Just Red) (Just Englishman) Nothing Nothing Nothing

S3_The_Spaniard_owns_the_dog : Habitant
S3_The_Spaniard_owns_the_dog =
  mkHabitant Nothing (Just Spaniard) (Just Dog) Nothing Nothing

S4_The_person_in_the_green_house_drinks_coffee : Habitant
S4_The_person_in_the_green_house_drinks_coffee = 
  mkHabitant (Just Green) Nothing Nothing (Just Coffee) Nothing

S5_The_Ukrainian_drinks_tea : Habitant
S5_The_Ukrainian_drinks_tea =
  mkHabitant Nothing (Just Ukrainian) Nothing (Just Tea) Nothing

S6_The_green_house_is_immediately_to_the_right_of_ivory_house : Correlated
S6_The_green_house_is_immediately_to_the_right_of_ivory_house =
  mkCorrelated (MC $ Just Ivory) 0 (MC $ Just Green) 0 False

S7_The_snail_owner_likes_to_go_dancing : Habitant
S7_The_snail_owner_likes_to_go_dancing =
  mkHabitant Nothing Nothing (Just Snail) Nothing (Just Dancing)

S8_The_person_in_the_yellow_house_is_a_painter : Habitant
S8_The_person_in_the_yellow_house_is_a_painter =
  mkHabitant (Just Yellow) Nothing Nothing Nothing (Just Painter)

S9_The_person_in_the_middle_house_drinks_milk : Habitant
S9_The_person_in_the_middle_house_drinks_milk =
  mkHabitant Nothing Nothing Nothing (Just Milk) Nothing

S10_The_Norwegian_lives_in_the_first_house : Habitant
S10_The_Norwegian_lives_in_the_first_house =
  mkHabitant Nothing (Just Norwegian) Nothing Nothing Nothing

S11_The_person_who_enjoys_reading_lives_in_the_house_next_to_the_person_with_the_fox :
  Correlated
S11_The_person_who_enjoys_reading_lives_in_the_house_next_to_the_person_with_the_fox =
  mkCorrelated (MH $ Just Reading) 4 (MP $ Just Fox) 2 True
  
S12_The_painter's_house_is_next_to_the_house_with_the_horse : Correlated
S12_The_painter's_house_is_next_to_the_house_with_the_horse =
  mkCorrelated (MH $ Just Painter) 4 (MP $ Just Horse) 2 True

S13_The_person_who_plays_football_drinks_orange_juice : Habitant
S13_The_person_who_plays_football_drinks_orange_juice =
  mkHabitant Nothing Nothing Nothing (Just Juice) (Just Football)

S14_The_Japanese_person_play_chess : Habitant
S14_The_Japanese_person_play_chess =
  mkHabitant Nothing (Just Japanese) Nothing Nothing (Just Chess)
  
S15_The_norwegian_lives_next_to_the_blue_house : Correlated
S15_The_norwegian_lives_next_to_the_blue_house =
  mkCorrelated (MN $ Just Norwegian) 1 (MC $ Just Blue) 0 True



public export
habitants : List Habitant
habitants =
  [ S2_The_Englishman_lives_in_the_red_house
  , S3_The_Spaniard_owns_the_dog
  , S4_The_person_in_the_green_house_drinks_coffee
  , S5_The_Ukrainian_drinks_tea
  , S7_The_snail_owner_likes_to_go_dancing
  , S8_The_person_in_the_yellow_house_is_a_painter
  , S13_The_person_who_plays_football_drinks_orange_juice
  , S14_The_Japanese_person_play_chess
  ]
  
public export
correlated : List Correlated
correlated =
  [ S6_The_green_house_is_immediately_to_the_right_of_ivory_house
  , S11_The_person_who_enjoys_reading_lives_in_the_house_next_to_the_person_with_the_fox
  , S12_The_painter's_house_is_next_to_the_house_with_the_horse
  , S15_The_norwegian_lives_next_to_the_blue_house
  ]

public export
neighborhood : Neighborhood
neighborhood =
  [ S10_The_Norwegian_lives_in_the_first_house
  , empty
  , S9_The_person_in_the_middle_house_drinks_milk
  , empty
  , empty
  ]
