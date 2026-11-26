# Variables declared on the command line
#       start
#       end

function verse(i) {
  printf "I know an old lady who swallowed a %s.\n%s%s",
    terms[i, 0], i == 2 ? "It" : "", terms[i, 1]
  if (i < 2 || i > 7) return
  for (--i; i > 0; --i)
    printf "\nShe swallowed the %s to catch the %s", terms[i + 1, 0],
      terms[i, 0] (i == 2 ? "." : " that" terms[i, 1])
  printf "\n" terms[1, 1] }

BEGIN {
  terms[1, 0] = "fly"; terms[2, 0] = "spider"; terms[3, 0] = "bird"
  terms[4, 0] = "cat"; terms[5, 0] = "dog";   terms[6, 0] = "goat"
  terms[7, 0] = "cow"; terms[8, 0] = "horse"
  terms[1, 1] = "I don't know why she swallowed the fly. Perhaps she'll die."
  terms[2, 1] = " wriggled and jiggled and tickled inside her."
  terms[3, 1] = "How absurd to swallow a bird!"
  terms[4, 1] = "Imagine that, to swallow a cat!"
  terms[5, 1] = "What a hog, to swallow a dog!"
  terms[6, 1] = "Just opened her throat and swallowed a goat!"
  terms[7, 1] = "I don't know how she swallowed a cow!"
  terms[8, 1] = "She's dead, of course!"
  verse(start)
  for (i = start + 1; i <= end; ++i) { print "\n"; verse(i) } }
