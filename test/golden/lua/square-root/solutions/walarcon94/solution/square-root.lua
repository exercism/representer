local SquareRoot = {}

function SquareRoot.square_root(radicand)
	if radicand < 0 then
		error("radicand cannot be negative")
	end

	local tolerance = 1e-10
	local guess = radicand
	while true do
		local next_guess = (guess + radicand / guess) / 2
		if math.abs(guess - next_guess) < tolerance then
			return next_guess
		end
		guess = next_guess
	end
end

return SquareRoot
