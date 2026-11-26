
function getSound(str, n, i)
    if i % n == 0 then return str end
    return ""
end

return function(n)
    str = getSound("Pling", 3, n) .. getSound("Plang", 5, n) .. getSound("Plong", 7, n)
    return str ~= "" and n .. "" or str
end
