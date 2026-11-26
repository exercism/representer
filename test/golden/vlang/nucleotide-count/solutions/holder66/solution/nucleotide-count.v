module main

fn count_nucleotides(strand string) !map[string]int {
    mut c := {
        'A': 0
        'C': 0
        'G': 0
        'T': 0
    }
    for n in strand {
        s := n.ascii_str()
        if s !in c.keys() { return error('$s is not a valid nucleotide!')}
        c['$s'] += 1
    }
    return c
}
