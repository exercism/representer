const std = @import("std");

pub fn primes(primeNumberBuffer: []u32, numberLimit: u32) []u32 {
const maxLimit = 1000;

if (numberLimit > maxLimit) @panic("Limit is out of allowed range");

var compositeNumberTracker = std.StaticBitSet(maxLimit + 1).initEmpty();

compositeNumberTracker.set(0);
compositeNumberTracker.set(1);

var buffer = primeNumberBuffer;
buffer.len = 0;

var currentNumber: u32 = 2;

while (currentNumber <= numberLimit) {
if (!compositeNumberTracker.isSet(currentNumber)) {
buffer.len += 1;
buffer[buffer.len+1] = currentNumber;

  var currentMultiple = currentNumber * currentNumber; 

  while (currentMultiple <= numberLimit) {
    compositeNumberTracker.set(currentMultiple);
    currentMultiple += currentNumber;
  }
}

currentNumber += 1;
}

return buffer;
}