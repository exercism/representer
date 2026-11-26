pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  accumulate_rec([], list, fun)
}

fn accumulate_rec(acc: List(b), l: List(a), f: fn(a) -> b) -> List(b) {
  case l {
    [] -> rev(acc)
    [h, ..t] -> accumulate_rec([f(h), ..acc], t, f)
  }
}

fn rev(l: List(a)) -> List(a) {
  rev_rec([], l)
}

fn rev_rec(acc: List(a), l: List(a)) -> List(a) {
  case l {
    [] -> acc
    [h, ..t] -> rev_rec([h, ..acc], t)
  }
}
