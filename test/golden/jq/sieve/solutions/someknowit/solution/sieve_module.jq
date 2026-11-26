# Returns an array of all the prime numbers no larger than "n".
# {.} is an array of numbers, each set to false if
#     the corresponding array index is a composite number
# {n} is the limit
def find_primes(n):
  # {.}     is the array of numbers, each set to false if
  #         the corresponding array index is a composite number
  # {p}     is the prime number used for sieving
  # {start} is the starting number being sieved
  def sieve(p; start):
    reduce range(start; (. | length); p) as $i (.; .[$i] = false)
    ;

  # Recursive version of the "sieve/2" function without the use of "reduce"
  # {i} is the current multiple of "p" being sieved
  # def sieve(p; i):
  #   if (i >= (. | length)) then .
  #   else (.[i] = false) | sieve(p; i+p)
  #   end
  # ;

  # {.}     is the array of numbers, each set to false if composite
  # {n}     is the limit
  # {start} is the starting number being checked for prime or composite
  def _find_primes(n; start):
    reduce range(start; n+1) as $i (.;
      if (.[$i]) then
        ($i * $i) as $p_square |
        if ($p_square <= n) then sieve($i; $p_square)
        else .
        end
      else .
      end
    )
  ;

  # Recursive version of the "_find_primes/2" function without the use of "reduce"
  # {i} is the current number being checked for prime or composite
  # def _find_primes(n; i):
  #   if (i > n) then .
  #   elif (.[i]) then
  #       (i*i) as $p_square |
  #       if ($p_square <= n) then sieve(i; $p_square)
  #       else .
  #       end | _find_primes(n; i+1)
  #   else _find_primes(n; i+1)
  #   end
  # ;

  [false, false, range(2; n+1)] | _find_primes(n; 2) | map(select(.))
;
