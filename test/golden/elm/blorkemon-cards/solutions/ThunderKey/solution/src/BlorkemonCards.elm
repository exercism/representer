module BlorkemonCards exposing
    ( Card
    , compareShinyPower
    , expectedWinner
    , isMorePowerful
    , maxPower
    , sortByCoolness
    , sortByMonsterName
    )


type alias Card =
    { monster : String, power : Int, shiny : Bool }


isMorePowerful : Card -> Card -> Bool
isMorePowerful card1 card2 =
    card1.power > card2.power


maxPower : Card -> Card -> Int
maxPower card1 card2 =
    max card1.power card2.power


sortByMonsterName : List Card -> List Card
sortByMonsterName =
    List.sortBy (\card -> card.monster)


sortByCoolness : List Card -> List Card
sortByCoolness =
    List.sortBy (\card -> ( -(boolToInt card.shiny), -card.power ))


compareShinyPower : Card -> Card -> Order
compareShinyPower card1 card2 =
    case ( compare card1.power card2.power, card1.shiny, card2.shiny ) of
        ( GT, _, _ ) -> GT
        ( LT, _, _ ) -> LT
        ( EQ, True, False ) -> GT
        ( EQ, False, True ) -> LT
        ( EQ, _, _ ) -> EQ


expectedWinner : Card -> Card -> String
expectedWinner card1 card2 =
    case compareShinyPower card1 card2 of
        GT -> card1.monster
        EQ -> "too close to call"
        LT -> card2.monster


boolToInt : Bool -> Int
boolToInt bool = if bool then 1 else 0