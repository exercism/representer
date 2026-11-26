module TwoBucket exposing (BucketNumber(..), measure)

import Set exposing (Set)

type BucketNumber
    = One
    | Two

type alias State =
    { moves : Int, bucketOne : Int, bucketTwo : Int }

-- Exposed --

measure : Int -> Int -> Int -> BucketNumber -> Maybe State
measure bucketOneSize bucketTwoSize goal startBucket =
    let initialState = { moves = 0, bucketOne = 0, bucketTwo = 0 }
        initialMemory = Set.singleton (toMemoryKey initialState)
    in solve [initialState] initialMemory bucketOneSize bucketTwoSize goal startBucket

-- Rules

pourOneInTwo : State -> Int -> State
pourOneInTwo state sizeTwo =
    let available = sizeTwo - state.bucketTwo
        toPour = min available state.bucketOne
    in { moves = state.moves + 1
        , bucketOne = state.bucketOne - toPour
        , bucketTwo = state.bucketTwo + toPour 
        }

pourTwoInOne : State -> Int -> State
pourTwoInOne state sizeOne =
    let available = sizeOne - state.bucketOne
        toPour = min available state.bucketTwo
    in { moves = state.moves + 1
        , bucketOne = state.bucketOne + toPour
        , bucketTwo = state.bucketTwo - toPour 
        }

emptyBucket : State -> BucketNumber -> State
emptyBucket state bucketNumber = case bucketNumber of
    One -> { state | moves = state.moves + 1, bucketOne = 0 }
    Two -> { state | moves = state.moves + 1, bucketTwo = 0 }

fillBucket : State -> Int -> BucketNumber -> State
fillBucket state bucketSize bucketNumber = case bucketNumber of
    One -> { state | moves = state.moves + 1, bucketOne = bucketSize }
    Two -> { state | moves = state.moves + 1, bucketTwo = bucketSize }

thirdRule : State -> Int -> Int -> BucketNumber -> Bool
thirdRule state bucketOneSize bucketTwoSize startBucket = case startBucket of
    One -> not (state.bucketOne == 0 && state.bucketTwo == bucketTwoSize)
    Two -> not (state.bucketTwo == 0 && state.bucketOne == bucketOneSize)

solved : State -> Int -> Bool
solved state goal = (state.bucketOne == goal) || (state.bucketTwo == goal)

-- Main loop

solve : List State -> Memory -> Int -> Int -> Int -> BucketNumber -> Maybe State
solve stateList memory bucketOneSize bucketTwoSize goal startBucket = case stateList of
    [] -> Nothing
    s::tail -> 
        if solved s goal then Just s
        else
            let all = reachableStates s bucketOneSize bucketTwoSize
                new = all
                    |> List.filter (\i -> thirdRule i bucketOneSize bucketTwoSize startBucket)
                    |> List.filter (\i -> not (alreadyReached i memory))
                nextMemory = addToMemory new memory
                nextStates = insertAllSorted new tail
            in solve nextStates nextMemory bucketOneSize bucketTwoSize goal startBucket

reachableStates : State -> Int -> Int -> List State
reachableStates s bucketOneSize bucketTwoSize =
    let oneInTwo = pourOneInTwo s bucketTwoSize
        twoInOne = pourTwoInOne s bucketOneSize
        emptyOne = emptyBucket s One
        emptyTwo = emptyBucket s Two
        fillOne = fillBucket s bucketOneSize One
        fillTwo = fillBucket s bucketTwoSize Two
    in [oneInTwo, twoInOne, emptyOne, emptyTwo, fillOne, fillTwo]

-- Helpers

type alias BucketState = Int
type alias MemoryKey = (BucketState, BucketState)
type alias Memory = Set MemoryKey

alreadyReached : State -> Memory -> Bool
alreadyReached state memory = Set.member (toMemoryKey state) memory

toMemoryKey : State -> (Int, Int)
toMemoryKey state = (state.bucketOne, state.bucketTwo)

addToMemory : List State -> Memory -> Memory
addToMemory new memory =
    let tuples = List.map toMemoryKey new
    in Set.union memory (Set.fromList tuples)

insertAllSorted : List State -> List State -> List State
insertAllSorted states stateList = List.foldl insertSorted stateList states

insertSorted : State -> List State -> List State
insertSorted state stateList = insertSortedRec [] state stateList

insertSortedRec : List State -> State -> List State -> List State
insertSortedRec acc state stateList = case stateList of
    [] -> List.reverse (state :: acc)
    h :: t -> 
        if h.moves > state.moves 
        then List.reverse ((state :: acc) ++ (h :: t))
        else insertSortedRec (h::acc) state t
