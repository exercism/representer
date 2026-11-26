module RolePlayingGame exposing (Player, castSpell, introduce, revive)


type alias Player =
    { name : Maybe String
    , level : Int
    , health : Int
    , mana : Maybe Int
    }


introduce : Player -> String
introduce { name } =
    Maybe.withDefault "Mighty Magician" name


revive : Player -> Maybe Player
revive player =
    if player.health > 0 then
        Nothing

    else
        let
            newMana =
                if player.level >= 10 then
                    Just 100

                else
                    Nothing
        in
        Just
            { player
                | health = 100
                , mana = newMana
            }


castSpell : Int -> Player -> ( Player, Int )
castSpell manaCost player =
    case player.mana of
        Nothing ->
            let
                updatedHealth =
                    if manaCost >= player.health then
                        0

                    else
                        player.health - manaCost
            in
            ( { player | health = updatedHealth }, 0 )

        Just m ->
            if m >= manaCost then
                ( { player | mana = Just (m - manaCost) }, manaCost * 2 )

            else
                ( player, 0 )
