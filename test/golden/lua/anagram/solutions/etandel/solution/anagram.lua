local class
class = function(defs)
    return {
        new = function(cls, ...)
            defs.init = defs.init or function() end
            local instance = setmetatable({}, {__index=defs})
            instance:init(...)
            return instance
        end
    }
end


local function sorted_str(str)
    local t = table.pack(str:lower():byte(1, #str))
    table.sort(t)
    for i, c in ipairs(t) do
        t[i] = string.char(c)
    end
    return table.concat(t)
end


return class({
    init = function(self, base)
        self.base = base:lower()
        self.letters = sorted_str(base)
    end;

    match = function(self, candidates)
        local matched = {}
        for _, c in ipairs(candidates) do
            if sorted_str(c) == self.letters and c:lower() ~= self.base then
                matched[#matched + 1] = c
            end
        end
        return matched
    end;
})