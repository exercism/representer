# These variables are initialized on the command line (using '-v'):
# - action
# - grade

function cmp_students(n1, g1, n2, g2) {
    if (g1 != g2) return g1 - g2
    return n1 < n2 ? -1 : 1
}

BEGIN {
    OFS = FS = ","
    PROCINFO["sorted_in"] = "cmp_students"
}

!($1 in students) { students[$1] = $2 }

END {
    NF = 0
    for (student in students)
        if (action == "roster" || students[student] == grade)
            $(++NF) = student
    print
}
