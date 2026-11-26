charset = function(word) {
  sort(strsplit(word, "")[[1]])
}

is_anagram = function(A, B) {
  A = tolower(A)
  B = tolower(B)
  identical(charset(A), charset(B)) & A != B
}

anagram = function(subject, candidates) {
  out <- candidates[mapply(is_anagram, subject, candidates)]
  if (length(out) == 0) NULL else out
}
