local function gcd(a, b)
  while b ~= 0 do
    a, b = b, a % b
  end
  return a
end

local function inverse(a, m)
  a = a % m
  b = m
  x, y = 0, 1
  while a ~= 0 do
    q, r = b // a, b % a
    x, y = y, x - q * y
    a, b = r, a
  end
  return x
end

local function validate_key(key)
  return gcd(key.a, 26) == 1 or error("a and m must be coprime.")
end
  
local function code(phrase, key)
  local cipher = ""
  for c in string.gmatch(string.lower(phrase), "%w") do
    if string.match(c, "%l") then
      local a = string.byte('a')
      c = string.char(a + (key.a * (string.byte(c) - a) + key.b) % 26)
    end
    cipher = cipher .. c
  end
  return cipher
end

local function group(text)
  local chunks = {}
  for i = 1, #text, 5 do
    table.insert(chunks, string.sub(text, i, i + 4))
  end
  return table.concat(chunks, " ")
end

local function encode(phrase, key)
  validate_key(key)
  return group(code(phrase, key))
end

local function decode(phrase, key)
  validate_key(key)
  local ainv = inverse(key.a, 26)
  return code(phrase, { a = ainv, b = -ainv * key.b })
end

return { encode = encode, decode = decode }
