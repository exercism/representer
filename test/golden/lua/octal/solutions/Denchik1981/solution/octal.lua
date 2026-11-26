return function(s)
  return {
    to_decimal = function()
        return tonumber(s, 8) or 0

    end
  }
end
