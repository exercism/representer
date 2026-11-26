module TopScorers exposing (..)

import Dict exposing (Dict)
import TopScorersSupport exposing (PlayerName)


updateGoalCountForPlayer : PlayerName -> Dict PlayerName Int -> Dict PlayerName Int
updateGoalCountForPlayer playerName playerGoalCounts =
    let
        addGoal maybeGoal = 
            case maybeGoal of
                Just goal ->
                    Just (goal + 1)
                Nothing ->
                    Just 1
    in
        Dict.update playerName addGoal playerGoalCounts
    --Debug.todo "implement updateGoalCountForPlayer function, to initialise or increment the goalcount for PlayerName"


aggregateScorers : List PlayerName -> Dict PlayerName Int
aggregateScorers playerNames =
    List.foldl updateGoalCountForPlayer Dict.empty playerNames
    --Debug.todo "Use List.foldl and updateGoalCountForPlayer to convert the list into a Dict"


removeInsignificantPlayers : Int -> Dict PlayerName Int -> Dict PlayerName Int
removeInsignificantPlayers goalThreshold playerGoalCounts =
    Dict.filter (\_ goals -> goals >= goalThreshold) playerGoalCounts
    --Debug.todo "implement removeInsignificantPlayers function, to remove players who have scored less than the threshold number of goals"


resetPlayerGoalCount : PlayerName -> Dict PlayerName Int -> Dict PlayerName Int
resetPlayerGoalCount playerName playerGoalCounts =
    Dict.insert playerName 0 playerGoalCounts
    --Debug.todo "implement resetPlayerGoalCount function, to reset the score of a player"


formatPlayer : PlayerName -> Dict PlayerName Int -> String
formatPlayer playerName playerGoalCounts =
    playerGoalCounts
        |> Dict.get playerName
        |> Maybe.map (\goal -> playerName ++ ": " ++ String.fromInt goal)
        |> Maybe.withDefault (playerName ++ ": 0")
    --Debug.todo "implement formatPlayer function, for use on the player profile page"


formatPlayers : Dict PlayerName Int -> String
formatPlayers players =
    players
    |> Dict.toList
    |> List.map (\player -> formatPlayer (Tuple.first player) players )
    |> String.join ", "
    --Debug.todo "implement formatPlayers function, for use on the Top Scorers page"


combineGames : Dict PlayerName Int -> Dict PlayerName Int -> Dict PlayerName Int
combineGames game1 game2 =
    Dict.merge
        (\name count mergedCounts -> Dict.insert name count mergedCounts)
        (\name countA countB mergedCounts -> Dict.insert name (countA - countB) mergedCounts)
        (\name count mergedCounts -> Dict.insert name count mergedCounts)
        game1
        game2
        Dict.empty
    --Debug.todo  "implement combineGames function, to calculate total scores played in both games"
