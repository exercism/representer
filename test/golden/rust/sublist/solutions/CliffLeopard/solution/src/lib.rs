#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist<T: PartialEq>(_first_list: &[T], _second_list: &[T]) -> Comparison {
    if _first_list == _second_list {
        return Comparison::Equal;
    } else {
        let first_len = _first_list.len();
        let second_len = _second_list.len();

        if first_len == 0 {
            Comparison::Sublist
        } else if second_len == 0 {
            Comparison::Superlist
        } else {
            if first_len == second_len {
                Comparison::Unequal
            } else if first_len > second_len {
                _first_list
                    .windows(second_len)
                    .find(|&w| w == _second_list)
                    .map_or(Comparison::Unequal, |_| Comparison::Superlist)
            } else {
                _second_list
                    .windows(first_len)
                    .find(|&w| w == _first_list)
                    .map_or(Comparison::Unequal, |_| Comparison::Sublist)
            }
        }
    }
}
