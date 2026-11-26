import times

proc addGigaSecond*(moment: DateTime): DateTime =
  moment + int(1e9).seconds
