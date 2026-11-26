-- Schema: CREATE TABLE "roman-numerals" ("number" INT, "result" TEXT);
-- Task: update the roman-numerals table and set the result based on the number.
with roman_digits(d, val, high) as (
    values ('M', 1000, 10000), ('CM', 900, 1000), ('D', 500, 900), ('CD', 400, 500), ('C', 100, 400),
        ('XC', 90, 100), ('L', 50, 90), ('XL', 40, 50), ('X', 10, 40), ('IX', 9, 10), ('V', 5, 9),
        ('IV', 4, 5), ('I', 1, 4)
)
update "roman-numerals"
set result = (
    with recursive
        parts(id, digit, rest) as (
            select 1, '', number union all
            select id + 1, d, rest - val from parts, roman_digits where rest < high and rest >= val
        )
    select group_concat(digit, '') from parts
)
