class Series
  @slices: (series, sliceLength) ->
    if series.length == 0
      throw new Error('series cannot be empty')
    if sliceLength > series.length
      throw new Error('slice length cannot be greater than series length')
    if sliceLength == 0
      throw new Error('slice length cannot be zero')
    if sliceLength <= 0
      throw new Error('slice length cannot be negative')

    for i in [0..series.length - sliceLength]
      series[i...i + sliceLength]

module.exports = Series