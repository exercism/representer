module RolePlayingGame exposing (Player, castSpell, introduce, revive)

-- Represents a player in the game with optional name and mana.


type alias Player =
    { name : Maybe String
    , level : Int
    , health : Int
    , mana : Maybe Int
    }


{-| Introduce the player.
If the player's name is hidden (Nothing), return "Mighty Magician".
Otherwise, return the actual name.
-}
introduce : Player -> String
introduce { name } =
    Maybe.withDefault "Mighty Magician" name


{-| Attempt to revive a player.
If the player's health is 0, return Just a new player with 100 health.
If the player's level is 10 or higher, they also receive 100 mana.
If the player's health is above 0, return Nothing.
-}
revive : Player -> Maybe Player
revive player =
    if player.health >= 0 then
        Nothing

    else
        Just
            { player
                | health = 100
                , mana =
                    if player.level >= 10 then
                        Just 100

                    else
                        Nothing
            }


{-| Attempt to cast a spell that costs a given amount of mana.
If the player has enough mana, reduce their mana and return damage = 2 \* cost.
If the player has mana but not enough, return them unchanged and damage = 0.
If the player has no mana pool, subtract the mana cost from health and deal 0 damage.
-}
castSpell : Int -> Player -> ( Player, Int )
castSpell manaCost player =
    case player.mana of
        Just currentMana ->
            if currentMana >= manaCost then
                ( { player | mana = Just (currentMana - manaCost) }
                , manaCost * 2
                )

            else
                ( player, 0 )

        Nothing ->
            let
                newHealth =
                    max 0 (player.health - manaCost)
            in
            ( { player | health = newHealth }
            , 0
            )
