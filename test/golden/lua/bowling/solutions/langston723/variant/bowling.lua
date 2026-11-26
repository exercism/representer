return function()
	local rolls = {}
	local frames = {}

	return {
		roll = function(pins)
			assert(pins >= 0 and pins <= 10)

			table.insert(rolls, pins)

			local current = frames[#frames]

			if #frames == 10 then
				if #current == 1 then
					if current[1] ~= 10 then
						assert(current[1] + pins <= 10, "too many pins!")
					end
				elseif #current == 2 then
					if current[1] == 10 and current[2] ~= 10 then
						assert(current[2] + pins <= 10, "too many pins!")
					elseif current[2] ~= 10 and current[1] + current[2] == 10 then
						error("too many rolls!")
					end
				elseif #current > 2 then
					error("too many rolls!")
				end
				table.insert(current, pins)
			elseif not current or current[1] == 10 or #current == 2 then
				table.insert(frames, { pins })
			else
				assert(current[1] + pins <= 10, "too many pins!")
				table.insert(current, pins)
			end
		end,

		score = function()
			local total = 0
			local i = 1
			local frame = 1

			while frame <= 10 do
				if rolls[i] == 10 then
					total = total + rolls[i] + rolls[i + 1] + rolls[i + 2]
					i = i + 1
					frame = frame + 1
				elseif rolls[i] + rolls[i + 1] == 10 then
					total = total + rolls[i] + rolls[i + 1] + rolls[i + 2]
					i = i + 2
					frame = frame + 1
				else
					total = total + rolls[i] + rolls[i + 1]
					i = i + 2
					frame = frame + 1
				end
			end

			return total
		end,
	}
end
