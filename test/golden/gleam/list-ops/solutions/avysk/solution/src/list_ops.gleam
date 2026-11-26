fn reverse_aux(acc: List(a), list: List(a)) -> List(a) {
  case list {
    [] -> acc
    [first, ..rest] -> reverse_aux([first, ..acc], rest)
  }
}

pub fn reverse(list: List(a)) -> List(a) {
  reverse_aux([], list)
}

fn prepend_rev_aux(acc: List(a), rlist: List(a)) -> List(a) {
  case rlist {
    [] -> acc
    [first, ..rest] -> prepend_rev_aux([first, ..acc], rest)
  }
}

pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  let rlist = reverse(first)
  prepend_rev_aux(second, rlist)
}

pub fn concat(lists: List(List(a))) -> List(a) {
  case lists {
    [] -> []
    [lst] -> lst
    [first, second, ..rest] -> concat([append(first, second), ..rest])
  }
}

fn filter_rev_aux(acc: List(a), rlist: List(a), f: fn(a) -> Bool) -> List(a) {
  case rlist {
    [] -> acc
    [first, ..rest] ->
      filter_rev_aux(
        case f(first) {
          True -> [first, ..acc]
          False -> acc
        },
        rest,
        f,
      )
  }
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  filter_rev_aux([], reverse(list), function)
}

pub fn length(list: List(a)) -> Int {
  case list {
    [] -> 0
    [_, ..rest] -> 1 + length(rest)
  }
}

fn map_rev_aux(acc: List(b), list: List(a), f: fn(a) -> b) -> List(b) {
  case list {
    [] -> acc
    [first, ..rest] -> map_rev_aux([f(first), ..acc], rest, f)
  }
}

pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  map_rev_aux([], reverse(list), function)
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [first, ..rest] ->
      foldl(over: rest, from: function(initial, first), with: function)
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  foldl(over: reverse(list), from: initial, with: function)
}
