module Sieve

||| Tack a list of Nats >= 2 and <= limit onto the front of someList
listNatsGteTwo : (limit : Nat) -> (someList : List Nat) -> List Nat
listNatsGteTwo Z l = l
listNatsGteTwo (S Z) l = l
listNatsGteTwo (S n) l = listNatsGteTwo n ((S n) :: l)

data PrimeyNat : Type where
    MkPrimeyNat : (possiblyPrime : Bool) -> (value : Nat) -> PrimeyNat

||| Rewrite theList of primeyNats, marking multiples of base,
||| starting at startingAt, as non-prime.
||| The PrimeyNats had better be in order lmao.
markMultiplesUnprime : (base : Nat) -> (startingAt : Nat) -> (theList : List PrimeyNat) -> List PrimeyNat
markMultiplesUnprime base startingAt [] = []
markMultiplesUnprime base startingAt (thisOne@(MkPrimeyNat isPrime n) :: theRest) =
    if n == startingAt then
        (MkPrimeyNat False startingAt) :: (markMultiplesUnprime base (startingAt + base) theRest)
    else
        thisOne :: (markMultiplesUnprime base startingAt theRest)

||| Rewrite a list of PrimeyNats using the Sieve of Eratosthenes algorithm
||| to mark the ones that are definitely not prime,
||| and then return just the prime ones, as Nats.
sieve : List PrimeyNat -> List Nat
sieve [] = []
sieve (MkPrimeyNat True n :: theRest) =
    n :: (sieve (markMultiplesUnprime n (n-n) theRest))
sieve (MkPrimeyNat False n :: theRest) =
    sieve theRest

export
primes : Nat -> List Nat
primes limit =
    sieve (map (\n => MkPrimeyNat True n) (listNatsGteTwo limit []))
