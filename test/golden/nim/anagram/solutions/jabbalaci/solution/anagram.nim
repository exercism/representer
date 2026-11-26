import strutils
import algorithm
import sequtils

func anagrams(s1, s2: string): bool =
  let
    s1 = s1.toLowerAscii
    s2 = s2.toLowerAscii

  if s1 == s2:
    return false    # same word isn't anagram

  sorted(s1, system.cmp) == sorted(s2, system.cmp)

func detectAnagrams*(word: string, candidates: seq[string]): seq[string] =
  candidates.filterIt(anagrams(word, it))
