//
// This is only a SKELETON file for the 'Series' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export class Series {
  constructor(series) {
    this.series = [];
    for (let number of series) {
      this.series.push(Number(number))
    };
  }

  slices(sliceLength) {
    if (this.series.length == 0) {
      throw new Error('series cannot be empty');
    } else if (sliceLength < 0) {
      throw new Error('slice length cannot be negative');
    } else if (sliceLength == 0) {
      throw new Error('slice length cannot be zero');
    } else if (this.series.length < sliceLength) {
      throw new Error('slice length cannot be greater than series length');
    } else if (this.series.length == sliceLength) {
      return [this.series];
    }
    let res = [];
    for (let i = 0; i <= this.series.length - sliceLength; i++) {
      let slice = [];
      for (let j = 0; j < sliceLength; j++) {
        slice.push(this.series[i + j]);
      }
      res.push(slice);
    }
    return res;
  }
}
