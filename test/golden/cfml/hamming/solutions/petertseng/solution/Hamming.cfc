component {
  /**
  * @returns the Hamming distance between the two
  */
  function distance(strand1, strand2) {
    if (strand1.len() != strand2.len()) {
      throw 'unequal length';
    }
    return strand1.map(function(c, i) {
      return c == strand2[i] ? '' : 'x';
    }, '').len();
  }
}