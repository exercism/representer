signature ALLYOURBASE = sig
  val rebase : int * int * int list -> int list option
end

structure AllYourBase : ALLYOURBASE = struct
  fun I x = x
  val all = List.all
  val zip = ListPair.zip
  val sum = foldl op+ 0

  val validate = let
    val allTrue = all I
    fun misd [] x = []
      | misd (f :: fs) x = f x :: misd fs x
    (* empty list, single zero, multiple zeros *)
    fun inputValid (b, b', d) = 0 <> sum d
    (* input base is zero, is negative *)
    fun inBaseValid (b, b', d) = b > 0
    (* output base is 1, is 0, is < 0 *)
    fun outBaseValid (b, b', d) = b' > 1
    (* negative digit, invalid positive digit *)
    fun validDigit b d = d < b andalso d > ~1
    fun validDigits (b, b', d) = List.all (validDigit b) d
    val validators = [inputValid, inBaseValid, outBaseValid, validDigits]
  in
    allTrue o misd validators
  end

  fun toInt (b, b', d) = let
    val tabulate = List.tabulate
    fun intPow b n = Int.fromLarge (IntInf.pow (Int.toLarge b, n))
    val basePower = intPow b
    fun powers d = rev (tabulate (length d, basePower))
    fun pair s = zip (s, powers s)
    val products = map op*
  in
    (sum o products o pair) d
  end

  fun toBase n b = let
    fun qr (a, b) = (Int.quot (a, b), Int.rem (a, b))
    fun f (q, r) b res =
      if q = 0
      then r :: res
      else r :: f (qr (q, b)) b res
  in
    rev (f (qr (n, b)) b [])
  end

  fun rebase (args as (b : int, b' : int, d : int list)) =
    if validate args
    then SOME (toBase (toInt args) b')
    else NONE
end

val rebase = AllYourBase.rebase
