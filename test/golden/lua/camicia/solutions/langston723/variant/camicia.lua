local paymentCards = {
	A = 4,
	K = 3,
	Q = 2,
	J = 1,
}

local function simulate_game(playerA, playerB)
	local tricks = 0
	local cards = 0
	local pile = {}
	local acting, waiting = playerA, playerB
	local paymentDue = 0
	local seen = {}

	-- HELPER FUNCTIONS
	local function playCard()
		local card = table.remove(acting, 1)
		pile[#pile + 1] = card
		return card
	end

	local function switchPlayer()
		acting, waiting = waiting, acting
	end

	local function pickupPile()
		for i = 1, #pile do
			waiting[#waiting + 1] = pile[i]
		end
		pile = {}
	end

	local function isGameOver()
		return #acting == 0
	end

	local function handKey(hand)
		local keys = {}
		for i = 1, #hand do
			local card = hand[i]
			if paymentCards[card] then
				keys[#keys + 1] = card
			else
				keys[#keys + 1] = "x"
			end
		end
		return table.concat(keys, ",")
	end

	local function stateKey()
		return table.concat({
			handKey(playerA),
			handKey(playerB),
		}, "|")
	end

	-- initial state
	local key = stateKey()
	seen[key] = true

	-- MAIN GAME LOOP
	local status = "playing"
	while true do
		if isGameOver() then
			tricks = tricks + 1
			status = "finished"
			break
		end

		local card = playCard()
		cards = cards + 1

		if paymentDue > 0 then
			if paymentCards[card] then
				switchPlayer()
				paymentDue = paymentCards[card]
			elseif paymentDue ~= 1 then
				paymentDue = paymentDue - 1

				pickupPile()

				tricks = tricks + 1

				if isGameOver() then
					status = "finished"
					break
				end

				key = stateKey()
				if seen[key] then
					status = "loop"
					break
				end
				seen[key] = true
			else
				paymentDue = paymentDue - 1
			end
		elseif paymentCards[card] then
			switchPlayer()
			paymentDue = paymentCards[card]
		end

		if paymentDue == 0 then
			switchPlayer()
		end
	end

	return { status = status, cards = cards, tricks = tricks }
end

return { simulate_game = simulate_game }
