local function eratos(n)
  return coroutine.create(function()
    local composite = {}
    for i = 2, n do
      if composite[i] == nil then
        coroutine.yield(i)
        for multiple = i * i, n, i do
          composite[multiple] = true
        end
      end
    end
  end)
end

return eratos
