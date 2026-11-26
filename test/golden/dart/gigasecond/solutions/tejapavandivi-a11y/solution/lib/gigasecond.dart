/// Adds one gigasecond (1,000,000,000 seconds) to a given moment.
DateTime addGigasecondTo(DateTime moment) {
  // 1. Define the gigasecond duration constant
  const int gigasecond = 1000000000;
  
  // 2. Add the duration to the baseline moment
  return moment.add(const Duration(seconds: gigasecond));
}
