fun rows (input: string): string list =
  let
    val n = ord (String.sub (input, 0)) - ord #"A"

    val length = 2 * n + 1

    val spaces: int -> string =
      let
        fun recurse (index: int): char list =
          if index = 0 then nil
          else #" " :: recurse (index - 1)
      in
        implode o recurse
      end

    fun generateRow (index: int): string =
      if index > n then generateRow(2 * n - index)
      else
        let
          val padding = spaces (n - index)
          val first = str (chr(ord(#"A") + index))
          val rest =
            if index > 0 then spaces (2 * index - 1) ^ first
            else "" 
        in
          padding ^ first ^ rest ^ padding
        end

    fun recurse (index: int): string list =
      if index = length then nil
      else generateRow(index) :: recurse (index + 2)
  in
    recurse(0)
  end
