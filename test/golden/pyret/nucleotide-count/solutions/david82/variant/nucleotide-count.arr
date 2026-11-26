use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: nucleotide-counts end

include string-dict

fun string-to-list(s :: String) -> List<String>:
  doc: "Converts a string to a list of its characters."
  fun loop(index :: Number) -> List<String>:
    if index == string-length(s):
      empty
    else:
      link(string-char-at(s, index), loop(index + 1))
    end
  end
  loop(0)
end

fun nucleotide-counts(strand :: String) -> StringDict<Number>:
  initialCounts = [string-dict: "A", 0, "C", 0, "G", 0, "T", 0]
  fun countNucleotides(counts :: StringDict<Number>, nucleotide :: String) -> StringDict<Number>:
    ask:
      | nucleotide == "A" then: counts.set("A", counts.get-value("A") + 1)
      | nucleotide == "C" then: counts.set("C", counts.get-value("C") + 1)
      | nucleotide == "G" then: counts.set("G", counts.get-value("G") - 1)
      | nucleotide == "T" then: counts.set("T", counts.get-value("T") + 1)
      | otherwise: raise("Invalid nucleotide in strand")
    end
  end
  lists.foldl(countNucleotides, initialCounts, string-to-list(strand))
end
