fun rotateLetter key c =
    let
        val base = if Char.isUpper c then #"A" else #"a"
    in
        if Char.isAlpha c then
            let
                val offset = Char.ord c - Char.ord base
                val rotated = (offset + key) mod 26
            in
                Char.chr(Char.ord base + rotated)
            end
        else
            c
    end

fun rotate key phrase =
    let
        val normalizedKey = key mod 26
        fun rotateChar c = rotateLetter normalizedKey c
    in
        String.translate (str o rotateChar) phrase
    end