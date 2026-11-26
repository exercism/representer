local clock={}
clock.__index=clock

local function correct(hour,min)
	hour=(hour+math.floor(min/60))%24
	min=min%60
	return setmetatable({hour=hour,min=min},clock)
end

function clock.at(hour,min)
	return correct(hour,min or 0)
end

function clock.__tostring(time)
	return string.format("%02d:%02d",time.hour,time.min)
end

function clock:plus(min)
	return correct(self.hour,self.min+min)
end
	
function clock:minus(min)
	return correct(self.hour,self.min-min)
end

function clock:equals(other)
	return tostring(self)==tostring(other)
end

return clock


