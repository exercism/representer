getPrimeNumbers <- function(maxn) {
  if (maxn<2) return(c());
  primeq = rep(T, maxn);
  primeq[1] = F;
  limit= floor(sqrt(maxn));
  for (kk in 1:limit) {
    if (primeq[kk]) {
      primeq[kk*(2:floor(maxn/kk))] = F
    }
  }
  primes = (1:maxn)[primeq];
  primes;
}
prime_factors <- function(number) {
  pf = c()
  dv = number;
  primes = getPrimeNumbers(floor(sqrt(number)));
  jj = 1;
  while (dv > 1) {
    if (jj > length(primes)) {
      pf = append(pf, dv);
      break;
    }
    if (dv %% primes[jj] == 0) {
     # print(paste(dv, primes[jj]));
      dv = dv / primes[jj];
      pf = append(pf, primes[jj]);
    } else {
      jj = jj + 1;
    }
  }
  pf;
}