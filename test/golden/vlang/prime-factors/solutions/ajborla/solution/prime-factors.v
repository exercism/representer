// ---------------------------------------------------------------------------
// exercism.org
// V Track Exercise: prime-factors
// Contributed: Anthony J. Borla (ajborla@bigpond.com)
// ---------------------------------------------------------------------------

module main

fn prime_factors(n i64) []i64 {
   mut factors := []i64{}
   if n < 2 { return factors }
   mut i := 2
   mut m := n
   for m > 1 {
      if m % i == 0 {
         factors << i
         m = m / i
         continue
      }
      i++
   }
   return factors
}
