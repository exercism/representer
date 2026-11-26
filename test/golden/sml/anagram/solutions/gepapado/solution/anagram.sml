fun anagramsFor subject candidates = let
  val (cs, cs') = (IntArray.array (26, 0), IntArray.array (26, 0))
  val strcasecmp = let
    fun compare (c1, c2) = Char.compare (Char.toLower c1, Char.toLower c2)
  in
    String.collate compare
  end
  fun inc cs c = 
    if not (Char.isAlpha c) then
      ()
    else let
      val i = ord (Char.toLower c) - ord #"a"
      val c = IntArray.sub (cs, i)
    in
      IntArray.update (cs, i, c + 1)
    end
  fun count cs s = CharVector.app (inc cs) s
  fun isAnagram s = 
    strcasecmp (s, subject) <> EQUAL andalso (
      IntArray.modify (fn c => 0) cs;
      count cs s;
      IntArray.collate Int.compare (cs, cs') = EQUAL
    )
in
  count cs' subject;
  List.filter isAnagram candidates
end