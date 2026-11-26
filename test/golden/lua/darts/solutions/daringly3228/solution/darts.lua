local Darts = {}

function Darts.score(x, y)
	-- 1 4 5 .. 10 5 1 0
	local score = 0
	local point = math.abs(math.sqrt(x ^ 2 + y ^ 2))
	if point <= 1 then
		score = 10
	elseif point <= 5 then
		score = 5
	elseif point <= 10 then
		score = 1
	end

	return score
end

return Darts
