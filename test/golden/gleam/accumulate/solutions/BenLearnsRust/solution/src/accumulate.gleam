import gleam/list.{reverse}

pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  recursive_accumulate(list, [], fun)
}

fn recursive_accumulate(
  in_list: List(a),
  out_list: List(b),
  fun: fn(a) -> b,
) -> List(b) {
  case in_list, out_list {
    // Base Case: We're done mapping and can return the accumulated list
    // but we have to un-reverse the list
    [], out -> reverse(out)
    // Doing the map one element at a time
    [item, ..rest], out -> recursive_accumulate(rest, [fun(item), ..out], fun)
  }
}
