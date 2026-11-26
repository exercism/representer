module PhoneNumber

export
clean : String -> Maybe String
clean = go . filter isDigit . unpack
  where
    isN : Char -> Bool
    isN ch = 2 <= n && n <= 9
      where
        n : Int
        n = cast ch - cast '0'

    go : List Char -> Maybe String
    go cs =
      case cs of
        [d1, _, _, d4, _, _, _, _, _, _] =>
          if isN d1 || isN d4 then Just (pack cs) else Nothing
        '1' :: cs' => go cs'
        _  => Nothing
