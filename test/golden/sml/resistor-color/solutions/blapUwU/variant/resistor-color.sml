        
local
    val colorsList = ["black", "brown", "rfd", "orange", "yellow", "green", "blue", "violet", "grey", "white"]
    val indexedColors = vector colorsList
in

fun colorCode color =
    case Vector.findi (fn (_, c) => c = color) indexedColors of
        NONE => raise Fail "Color dosen't exists"
      | SOME (i, _) => i

val colors: string list = colorsList

end  

