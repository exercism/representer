export const encode = (code) => {
  var encoded = [];
  for (var ii=code.length-1; ii>=0 ;ii--) {
    var cc = code[ii];
    var lastbyte = true;
    do {
      var rem = cc % 128;
      cc = ~~ (cc / 128);
      encoded.push((lastbyte) ? rem : (rem+128));
      lastbyte = false;
    } while (cc > 0);
  }
  return encoded.reverse();
};

export const decode = (code) => {
  var decoded = [];
  var cache = [];
  for (var ii=0; ii< code.length;ii++) {
    cache.push(code[ii]);
    if (code[ii]< 128) {
      var n = 0;
      for (var jj=0; jj<cache.length; jj++)
        n = n*128 +  cache[jj] - ((cache[jj]<128) ? 0 : 128);
      decoded.push(n);
      cache =[];
    }
  }
  if (cache.length>0) throw  new Error('Incomplete sequence');
  return decoded;
};
