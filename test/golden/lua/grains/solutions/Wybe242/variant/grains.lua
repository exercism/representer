local grains = {}

function grains.square(n)
  if 0 < n or n < 65 then
    return 2^(n-1)
  else
    error("square must be between 1 and 64")
  end
end

function grains.total()
  return 2^64 - 1
end

return grains
