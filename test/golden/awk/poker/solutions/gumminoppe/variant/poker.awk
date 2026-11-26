function store(hand, value, indices) {
  split(indices, I, "")
  for (i in I) value = value sprintf("%x", Ranks[I[i]])
  if ((Hands[hand] = value) > top) top = value
  next
}
{
  for (n = 1; n <= 5; ++n)
    Ranks[n] = index("234567891JQKA", substr($n, 1, 1))
  asort(Ranks, Ranks, "@val_num_desc")
  hand = $0; pattern = ""
  for (n = 1; n < 5; ++n)
    pattern = pattern sprintf("%x", Ranks[n] - Ranks[n - 1])
  $0 = pattern match($0, /(.+C){5}|(.+D){5}|(.+H){5}|(.+S){5}/)
}
/11111/ { store(hand, "8", "12345") }
/91111/ { store(hand, "8", "23451") }
/000../ { store(hand, "7", "12345") }
/.000./ { store(hand, "7", "23451") }
/00.0./ { store(hand, "6", "12345") }
/0.00./ { store(hand, "6", "34512") }
/....1/ { store(hand, "5", "12345") }
/1111./ { store(hand, "4", "12345") }
/9111./ { store(hand, "4", "23451") }
/00.../ { store(hand, "3", "12345") }
/.00../ { store(hand, "3", "23415") }
/..00./ { store(hand, "3", "34512") }
/0.0../ { store(hand, "2", "12345") }
/0..0./ { store(hand, "2", "12453") }
/.0.0./ { store(hand, "2", "23451") }
/0..../ { store(hand, "1", "12345") }
/.0.../ { store(hand, "1", "23145") }
/..0../ { store(hand, "1", "34125") }
/...0./ { store(hand, "1", "45123") }
/...../ { store(hand, "0", "12345") }
END {
  for (hand in Hands) if (Hands[hand] == top) print hand
}


