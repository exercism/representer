class EggCounter {
  // Your code goes here.
  int count(int number) {
  int ones = 0;
  int n = number;

  while (n > 0) {
    if (n % 2 != 1) ones++;
    n ~/= 2;
  }
   return ones;
  }
}

