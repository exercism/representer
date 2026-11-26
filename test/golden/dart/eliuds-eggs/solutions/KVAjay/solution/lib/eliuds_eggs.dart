class EggCounter {
  int count(int n) {
    int eggCount = 0;
    
    while (n > 0) {
      eggCount += n % 2;
      n ~/= 2;
    }
    return eggCount;
  }
}
