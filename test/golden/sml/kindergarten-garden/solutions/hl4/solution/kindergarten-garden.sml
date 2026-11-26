fun plants diagram student =
  let
    val place = (ord (String.sub (student, 0)) - ord #"A") * 2
    fun pot (row, col) = String.sub (diagram, row * (size diagram div 2 + 1) + col)
    fun plant sym = case sym of #"R" => "radishes" | #"G" => "grass" | #"V" => "violets" | #"C" => "clover"
  in
    map plant [pot (0, place), pot (0, place + 1), pot (1, place), pot (1, place + 1)]
  end