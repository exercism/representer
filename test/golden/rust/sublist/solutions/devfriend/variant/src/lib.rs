#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist(first_list: &[i32], second_list: &[i32]) -> Comparison {
    if equal(first_list, second_list) {
        Comparison::Equal
    } else if superlist(first_list, second_list) {
        Comparison::Superlist
    } else if sublist_bool(first_list, second_list) {
        Comparison::Sublist
    } else {
        Comparison::Unequal
    }
}

fn equal(first_list: &[i32], second_list: &[i32]) -> bool {
    first_list == second_list
}

fn superlist(first_list: &[i32], second_list: &[i32]) -> bool {
    if second_list.is_empty() {
        true
    } else {
        first_list
            .windows(second_list.len())
            .find(|window| *window != second_list)
            .map_or_else(|| false, |_| true)
    }
}

fn sublist_bool(first_list: &[i32], second_list: &[i32]) -> bool {
    superlist(second_list, first_list)
}
