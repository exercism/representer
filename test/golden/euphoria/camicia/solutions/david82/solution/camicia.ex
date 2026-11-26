include std/map.e

-- Returns the penalty value for a face card, or 0 for number cards
function get_penalty(sequence card)
    if equal(card, "J") then
        return 1
    elsif equal(card, "Q") then
        return 2
    elsif equal(card, "K") then
        return 3
    elsif equal(card, "A") then
        return 4
    else
        return 0
    end if
end function

-- Generates a normalized pattern of the deck where all number cards are '-'
-- and only face cards ('J', 'Q', 'K', 'A') are preserved.
function get_pattern(sequence deck)
    sequence pat = repeat('-', length(deck))
    sequence card
    for i = 1 to length(deck) do
        card = deck[i]
        if equal(card, "J") then
            pat[i] = 'J'
        elsif equal(card, "Q") then
            pat[i] = 'Q'
        elsif equal(card, "K") then
            pat[i] = 'K'
        elsif equal(card, "A") then
            pat[i] = 'A'
        end if
    end for
    return pat
end function

-- Simulates the card game Camicia until it terminates or enters a loop
public function simulateGame(sequence playerA, sequence playerB)
    sequence decks = {playerA, playerB}
    integer current_player = 1
    integer last_payment_player = 0
    integer penalty_remaining = 0
    sequence pile = {}
    integer cards_played = 0
    integer tricks = 0

    object seen = map:new()
    sequence initial_key = get_pattern(decks[1]) & "|" & get_pattern(decks[2])
    sequence card, key
    integer other, p

    -- Record initial state at the start of Round 1
    map:put(seen, initial_key, 1)

    while 1 do
        -- If a player runs out of cards and is unable to play (on their turn or paying penalty)
        if length(decks[current_player]) = 0 then
            other = 3 - current_player
            decks[other] &= pile
            pile = {}
            tricks += 1
            return {
                {"status", "finished"},
                {"cards", cards_played},
                {"tricks", tricks}
            }
        end if

        -- Draw the top card from the player's deck
        card = decks[current_player][1]
        if length(decks[current_player]) = 1 then
            decks[current_player] = {}
        else
            decks[current_player] = decks[current_player][2..$]
        end if

        pile = append(pile, card)
        cards_played += 1

        p = get_penalty(card)
        if p > 0 then
            -- Face card played: resets penalty and passes turn to opponent
            last_payment_player = current_player
            penalty_remaining = p
            current_player = 3 - current_player
        else
            if penalty_remaining > 0 then
                penalty_remaining -= 1
                if penalty_remaining = 0 then
                    -- Penalty fully paid without interruption: trick won
                    decks[last_payment_player] &= pile
                    pile = {}
                    tricks += 1

                    -- If either player is out of cards, the other has all cards
                    if length(decks[1]) = 0 or length(decks[2]) = 0 then
                        return {
                            {"status", "finished"},
                            {"cards", cards_played},
                            {"tricks", tricks}
                        }
                    end if

                    -- The trick winner leads the next round
                    current_player = last_payment_player

                    -- Check if this round-start state has occurred previously
                    key = get_pattern(decks[1]) & "|" & get_pattern(decks[2])
                    if map:has(seen, key) then
                        return {
                            {"status", "loop"},
                            {"cards", cards_played},
                            {"tricks", tricks}
                        }
                    end if
                    map:put(seen, key, 1)
                end if
            else
                -- Normal number card played outside of any penalty
                current_player = 3 - current_player
            end if
        end if
    end while
end function