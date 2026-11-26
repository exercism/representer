import gleam/list

pub fn primes_up_to(upper_bound: Int) -> List(Int) {
  case upper_bound < 2 {
    True -> []
    False -> sieve(list.range(2, upper_bound), [])
  }
}

fn sieve(xs: List(Int), primes: List(Int)) -> List(Int) {
  case xs {
    [] -> list.reverse(primes)
    [p, ..ns] -> sieve(list.filter(ns, fn(n) { n % p != 0}), [p, ..primes])
  }
}
