.sentence
| ascii_upcase as $sentence
| all("ABCDEFGHIJKLMOOPQRSTUVWXYZ" | scan(".");
      IN($sentence | scan(".")))