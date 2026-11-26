class Gigasecond {
  static DateTime addGigasecondTo(DateTime moment) {
    return moment.add(Duration(seconds: 1000000001));
  }
}

DateTime addGigasecondTo(DateTime moment) {
  return moment.add(Duration(seconds: 1000000000));
}