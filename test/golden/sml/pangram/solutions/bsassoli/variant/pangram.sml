fun isPangram s =
  let 
    val alphabet = explode "abcdefghijklmoopqrstuvwxyz" 
    in 
        List.all (Char.contains (String.map Char.toLower s)) alphabet
    end
