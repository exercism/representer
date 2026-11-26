def nucl_to_nucl (a: u8): u8 =
  match a
  case 'G' -> 'C'
  case 'C' -> 'G'
  case 'T' -> 'A'
  case 'A' -> 'U'
  case _  -> a


def to_rna [n] (dna: [n]u8): [n]u8 =
  filter nucl_to_nucl dna
