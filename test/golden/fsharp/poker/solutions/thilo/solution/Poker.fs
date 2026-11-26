module Poker

type Rank =
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Jack
    | Queen
    | King
    | Ace

type Card = Rank*string
type Hand = { cards: Card List }

let rankByRankString =
    Map [ ("2", Two)
          ("3", Three)
          ("4", Four)
          ("5", Five)
          ("6", Six)
          ("7", Seven)
          ("8", Eight)
          ("9", Nine)
          ("10", Ten)
          ("J", Jack)
          ("Q", Queen)
          ("K", King)
          ("A", Ace) ]

let Ranking isStraight=
    let aceValue = if isStraight then 0 else 13
    Map [ (Two, 1)
          (Three, 2)
          (Four, 3)
          (Five, 4)
          (Six, 5)
          (Seven, 6)
          (Eight, 7)
          (Nine, 8)
          (Ten, 9)
          (Jack, 10)
          (Queen, 11)
          (King, 12)
          (Ace, aceValue) ]



let rev map: Map<Rank, string> =
    Map.fold (fun m key value -> m.Add(value, key)) Map.empty map

let rankStringByRank = rev rankByRankString

module Parsing =
    let createCard (input: string) =
        Card ( rankByRankString.[input.Substring(0, input.Length - 1)],
          input.[input.Length - 1] |> string)

    let createHand (input: string): Hand =
        input.Split ' '
        |> Array.toList
        |> List.map (createCard)
        |> fun c -> { cards = c }

    let handToString (hand: Hand): string =
        hand.cards
        |> List.map (fun (rank, suite) -> rankStringByRank.[rank] + suite)
        |> List.fold (fun elem acc -> sprintf "%s %s"elem acc) ""
        |> fun s -> s.[1..]

module Rules =
    type Result = int List

    type Rule =
        { nextRule: Rule option
          applies: Hand -> bool
          count: Hand -> Result
          onEqual: Hand -> Result }

    let getDuplicatesRank hand amount =
        hand.cards
        |> List.groupBy (fun (rank,_) -> rank)
        |> List.choose (fun (k, v) ->
            match v.Length with
            | x when x = amount -> Some k
            | _ -> None)

    let singleResToResult (value: int): Result = [ value ]
    let splitPot = 0 |> singleResToResult

    let highestCardCountRule =
        (fun h ->
            h.cards
            |> List.map (fun (rank,_) -> (Ranking false).[rank])
            |> List.sortDescending)

    let highestCard: Rule =
        { applies = (fun _ -> true)
          nextRule = None
          count = highestCardCountRule
          onEqual = highestCardCountRule }

    let pair: Rule =
        { applies = (fun h -> getDuplicatesRank h 2 |> List.isEmpty |> not)
          nextRule = Some(highestCard)
          count =
              (fun h ->
                  getDuplicatesRank h 2
                  |> List.map (fun rank -> (Ranking false).[rank])
                  |> List.sortDescending)
          onEqual =
              (fun h ->
                  let ranksToRemove = getDuplicatesRank h 2

                  let kickers =
                      h.cards
                      |> List.filter (fun (rank,_) -> ranksToRemove |> List.contains rank |> not)

                  highestCard.count { cards = kickers }) }

    let twoPair: Rule =
        { applies = (fun h -> getDuplicatesRank h 2 |> List.length = 2)
          nextRule = Some(pair)
          count =
              (fun h ->
                  getDuplicatesRank h 2
                  |> List.map (fun rank -> (Ranking false).[rank])
                  |> List.sortDescending)
          onEqual =
              (fun h ->
                  let ranksToRemove = getDuplicatesRank h 2

                  let kickers =
                      h.cards
                      |> List.filter (fun (rank,_) -> ranksToRemove |> List.contains rank |> not)

                  highestCard.count { cards = kickers }) }

    let threeOfAKind: Rule =
        { applies = (fun h -> getDuplicatesRank h 3 |> List.isEmpty |> not)
          nextRule = Some(twoPair)
          count =
              (fun h ->
                  getDuplicatesRank h 3
                  |> List.map (fun rank -> (Ranking false).[rank])
                  |> List.sortDescending)
          onEqual =
              (fun h ->
                  let ranksToRemove = getDuplicatesRank h 3

                  let kickers =
                      h.cards
                      |> List.filter (fun (rank,_) -> ranksToRemove |> List.contains rank |> not)

                  highestCard.count { cards = kickers }) }

    let straight: Rule =
        { applies =
              (fun h ->
                  let rec _isAStraight (sortedHand: Card list) (last: Rank,_): bool =
                      match sortedHand with
                      | (headRank, headSuite) :: tail ->
                          if (headRank = Rank.Ace && last = Rank.Five) then
                              true
                          else if ((Ranking false).[headRank] - 1 = (Ranking false).[last]) then
                              _isAStraight tail (headRank, headSuite)
                          else
                              false
                      | [] -> true

                  let sortedHands = h.cards |> List.sortBy (fun (rank,_) -> rank)
                  _isAStraight sortedHands.Tail sortedHands.Head)
          nextRule = Some(threeOfAKind)
          count =
              (fun h ->
                  h.cards
                  |> List.map (fun (rank,_) -> (Ranking true).[rank])
                  |> List.max
                  |> singleResToResult)
          onEqual = (fun _ -> splitPot) }

    let flush: Rule =
        { applies =
              (fun h ->
                  let (_,baseSuite) = h.cards.Head
                  h.cards
                  |> List.filter (fun (_, suite) -> suite = baseSuite)
                  |> List.length = 5)
          nextRule = Some(straight)
          count = (fun _ -> splitPot)
          onEqual = highestCard.count }

    let fullHouse: Rule =
        { applies = (fun h -> threeOfAKind.applies (h) && pair.applies (h))
          nextRule = Some(flush)
          count = (fun h -> threeOfAKind.count (h) @ pair.count (h))
          onEqual = (fun _ -> splitPot) }

    let fourOfAKind: Rule =
        { applies = (fun h -> getDuplicatesRank h 4 |> List.isEmpty |> not)
          nextRule = Some(fullHouse)
          count =
              (fun h ->
                  getDuplicatesRank h 4
                  |> List.map (fun rank -> (Ranking false).[rank])
                  |> List.sortDescending)
          onEqual =
              (fun h ->
                  let ranksToRemove = getDuplicatesRank h 4
                  let kickers =
                      h.cards
                      |> List.filter (fun (rank,_) -> ranksToRemove |> List.contains rank |> not)
                  highestCard.count { cards = kickers }) }

    let straightFlush: Rule =
        { applies = (fun h -> straight.applies (h) && flush.applies (h))
          nextRule = Some(fourOfAKind)
          count = straight.count
          onEqual = fun _ -> splitPot }

    let royalFlush: Rule =
        { applies =
              (fun h ->
                  straightFlush.applies (h)
                  && h.cards
                     |> List.sortByDescending (fun (rank,_) -> (Ranking false).[rank])
                     |> List.map fst = [ Ace; King; Queen; Jack; Ten ])
          nextRule = Some(straightFlush)
          count = (fun _ -> splitPot)
          onEqual = fun _ -> splitPot }

let bestHands (hands: string List): string List =
    let rec _winningHandsFromScoreByHand (countByHand: Map<Hand, Rules.Result>) (index: int): Hand list =
        let countByHandOnCurrentIndex: (Hand * int) list =
            countByHand
            |> Map.toList
            |> List.map (fun (hand, results) -> (hand, results.[index]))
        let (_, aMaxHandValue): Hand * int =
            countByHandOnCurrentIndex |> List.maxBy snd


        let equalingOnIndex: Hand list =
            countByHandOnCurrentIndex
            |> List.filter (fun (_, c) -> c = aMaxHandValue)
            |> List.map fst

        let size: int =
            countByHand
            |> Map.toList
            |> List.head
            |> (fun (_, r) -> r.Length)

        match equalingOnIndex.Length with
        | 1 -> equalingOnIndex 
        | _ when (index + 1) = size -> equalingOnIndex 
        | _ ->
            let keyIsInList (key: Hand): bool = equalingOnIndex |> List.contains key

            let qualifyingHands: Map<Hand, Rules.Result> =
                countByHand
                |> Map.filter (fun handKey _ -> keyIsInList handKey)

            _winningHandsFromScoreByHand qualifyingHands (index + 1)

    let _bestHandsForCountRule (appliers: Hand list) (countRule: Hand -> Rules.Result): Hand list =
        let countByHand: Map<Hand, Rules.Result> =
            appliers
            |> List.map (fun h -> (h, countRule (h)))
            |> Map.ofList

        _winningHandsFromScoreByHand countByHand 0

    let rec _evaluate (hands: Hand List) (currentRule: Rules.Rule): Hand List =
        let appliesByHand: Map<Hand, bool> =
            hands
            |> List.map (fun h -> (h, currentRule.applies (h)))
            |> Map.ofList

        let allAppliers: Hand list =
            appliesByHand
            |> Map.filter (fun _ applies -> applies = true)
            |> Map.toList
            |> List.map fst

        match allAppliers.Length with
        | 0 -> _evaluate hands currentRule.nextRule.Value 
        | 1 -> allAppliers 
        | _ ->
            let handsWithSameCount =
                _bestHandsForCountRule allAppliers currentRule.count

            match handsWithSameCount.Length with
            | 1 -> handsWithSameCount 
            | _ -> _bestHandsForCountRule handsWithSameCount currentRule.onEqual

    let parsedHands = hands |> List.map Parsing.createHand

    _evaluate parsedHands Rules.royalFlush
    |> List.map Parsing.handToString
    |> List.rev