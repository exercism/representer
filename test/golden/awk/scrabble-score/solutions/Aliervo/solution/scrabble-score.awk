BEGIN {
  FS = "";
  score = 0;
}

{
  for (i=1; i < NF + 1; i++) {
    switch (toupper($i)) {
      # Use regex to keep OR matches short
      # Use fall through to continue add up to total score
      case /[QZ]/:
        score += 2;
      case /[JX]/:
        score += 3;
      case /K/:
        score += 1;
      case /[FHVWY]/:
        score += 1;
      case /[BCMP]/:
        score += 1;
      case /[DG]/:
        score += 1;
      case /[AEIOULNRST]/:
        score += 1;
    }
  }
}

END {
  print toupper($0) "," score;
}
