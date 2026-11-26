#[derive(Drop, Debug, PartialEq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

fn isInside<T, +PartialEq<T>>(a: @Array<T>, b: @Array<T>) -> bool {
    if a.len() > b.len() {
        return false;
    }
    let mut i = 0;
    let mut r = false;
    while i <= b.len() - a.len() {
        if b.span().slice(i, a.len()) == a.span() {
            r = true;
            break;
        }
        i += 1;
    };
    return r;
}

pub fn sublist<T, +PartialEq<T>>(a: @Array<T>, b: @Array<T>) -> Comparison {
    if a.span() == b.span() {
        return Comparison::Equal;
    }
    if isInside(a, b) {
        return Comparison::Sublist;
    }
    if isInside(b, a) {
        return Comparison::Superlist;
    }
    return Comparison::Unequal;
}
