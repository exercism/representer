fun isPangram s =
    let 
        val alphabet = String.explode "abcdefghijklmnopqrstuvwxyz"
    in
      List.all (Char.contains (String.map Char.toLower s)) alphabet
    end
