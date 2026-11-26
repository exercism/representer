fun isPangram s =
    let 
        val alphabet = String.explode "abcdefghijklmoopqrstuvwxyz"
    in
      List.all (Char.contains (String.map Char.toLower s)) alphabet
    end
