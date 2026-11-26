class Series {

    static slices(series, sliceLength) {
      if (sliceLength<1 || series.isEmpty() || sliceLength>series.size()) throw new ArithmeticException('')
      (0..((series.size())-sliceLength)).collect{series[it..it-1+sliceLength]}
    }
}