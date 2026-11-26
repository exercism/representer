class PrimeFactors {
  List<int> factors(int number) {
    if (number == 1) {
      return [];
    }

    List<int> primeFactors = [];
    int devisor = 2;

    while (number >= devisor) {
      if (number % devisor == 0) {
        primeFactors.add(devisor);
        number ~/= devisor;
      } else {
        devisor++;
      }
    }

    return primeFactors;
  }
}
