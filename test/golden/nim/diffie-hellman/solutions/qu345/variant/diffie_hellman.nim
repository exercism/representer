import std/[random, math]

randomize()

proc privateKey*(p: int): int =
  rand(3..<p)

proc publicKey*(p, g, pK: int): int =
  g^pK mod p

proc secret*(p, theirPK, myPK: int): int =
  theirPK^myPK mod p
