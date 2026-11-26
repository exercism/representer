def value(c):
    ["black", "brown", "red", "orange", "yellow",
     "green", "blue", "violet", "grey", "white"] | index(c)
;

def pow10(n):
    reduce range(n) as $i (1; . * 10)
;

def scale(n):
    [{divisor: 1000000000, unit: "gigaohms"},
     {divisor: 1000000, unit: "megaohms"},
     {divisor: 1000, unit: "kiloohms"},
     {divisor: 1, unit: "ohms"}]
    | map(select(n % .divisor == 0)) | first
    | {value: (n / .divisor), unit: .unit}
;

.colors as $c |
((10 * value($c[0]) + value($c[1])) * pow10(value($c[2]))) as $ohms |
if $ohms == 0 then
    {value: 0, unit: "ohms"}
else
    scale($ohms)
end
