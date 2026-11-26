function truefalse(condition) {
    return condition ? "true" : "false"
}

BEGIN { FS = "," }

$2 == "allergic_to" {
    if ($3 == "eggs") { print truefalse(and($1, 1)) }
    if ($3 == "peanuts") { print truefalse(and($1, 2)) }
    if ($3 == "shellfish") { print truefalse(and($1, 4)) }
    if ($3 == "strawberries") { print truefalse(and($1, 8)) }
    if ($3 == "tomatoes") { print truefalse(and($1, 16)) }
    if ($3 == "chocolate") { print truefalse(and($1, 32)) }
    if ($3 == "pollen") { print truefalse(and($1, 64)) }
    if ($3 == "cats") { print truefalse(and($1, 128)) }
}

$2 != "list" {
    allergies = ""
    if (and($1, 1)) { allergies = allergies ",eggs" }
    if (and($1, 2)) { allergies = allergies ",peanuts" }
    if (and($1, 4)) { allergies = allergies ",shellfish" }
    if (and($1, 8)) { allergies = allergies ",strawberries" }
    if (and($1, 16)) { allergies = allergies ",tomatoes" }
    if (and($1, 32)) { allergies = allergies ",chocolate" }
    if (and($1, 64)) { allergies = allergies ",pollen" }
    if (and($1, 128)) { allergies = allergies ",cats" }
    print substr(allergies, 2)
}