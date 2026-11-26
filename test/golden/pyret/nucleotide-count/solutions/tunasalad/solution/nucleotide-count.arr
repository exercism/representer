use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: nucleotide-counts end

include string-dict

fun nucleotide-counts(strand) -> StringDict:
  res0 = [string-dict: "A", 0, "C", 0, "G", 0, "T", 0]
  range(0, string-length(strand))
  .foldl(lam(i, res):
    nuc = string-char-at(strand, i)
    cases(Option) res.get(nuc):
      | none => raise("Invalid nucleotide in strand")
      | some(c) => res.set(nuc, c + 1)
    end
  end, res0)
end