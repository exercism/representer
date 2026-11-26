local function to_decimal(input)
  return tonumber(input, 2) or 0
end

return {
  to_decimal = to_decimal
}
