is_armstrong = (num) ->
    a = tostring(num)
    n = #a
    s = {a\byte(1, n)}
    res = 0
    for _, v in ipairs(s)
        res += (v - 48) ^ n
    res == num
{ :is_armstrong }