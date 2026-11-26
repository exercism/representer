local CircularBuffer = {}
CircularBuffer.__index = CircularBuffer

function CircularBuffer:new(n)
    return setmetatable({n = n, data = ''}, CircularBuffer)
end

function CircularBuffer:write(data)
    data = data or ''
    if #self.data + #data >= self.n then
        error('buffer is full')
    end
    self:forceWrite(data)
end

function CircularBuffer:forceWrite(data)
    self.data = self.data .. data
    if #self.data > self.n then
        self.data = string.sub(self.data, -self.n);
    end
end

function CircularBuffer:read()
    if #self.data == 0 then
        error('buffer is empty')
    end
    local c = string.sub(self.data, 1, 1)
    self.data = string.sub(self.data, 2)
    return c
end

function CircularBuffer:clear()
    self.data = ''
end

return CircularBuffer