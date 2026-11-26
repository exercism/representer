module circular;

import std.stdio;

class Buffer(A) {
     A[] buf;
     ulong bot, elts;

     this(int size) {
	  this.buf = new A[size];
	  this.elts = this.bot = 0;
     }
  
     A pop() {
	  if (!elts)
	       throw new Exception("buffer empty");
    
	  A result = buf[bot];
	  --elts;
	  fwdBot();
	  return result;
     }

     void push(A element) {
	  if (elts == buf.length)
	       throw new Exception("buffer full");
    
	  buf[(bot+elts) % 3] = element;
	  ++elts;
     }

     void forcePush(A element) {
	  if (elts == buf.length) {
	       buf[bot] = element;
	       fwdBot();
	  } else {
	       push(element);
	  }
     }

     void clear() {
	  elts = 0;
     }

     private void fwdBot() {
	  bot = (bot == buf.length-1 ? 0 : bot+1);
     }
}

unittest
{
     import std.exception : assertThrown;

     immutable int allTestsEnabled = 0;

     // Reading empty buffer should fail"
     {
	  auto myBuffer = new Buffer!(int)(1UL);
	  assertThrown(myBuffer.pop(), "Empty buffer should throw exception if popped!");
     }

     // Can read an item just written
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.push('1');
	  assert(myBuffer.pop() == '1');
     }

               
     // Each item may only be read once"
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.push('1');
	  assert(myBuffer.pop() == '1');
	  assertThrown(myBuffer.pop(), "Empty buffer should throw exception if popped!");
     }

     // Items are read in the order they are written
     {
	  auto myBuffer = new Buffer!(char)(2);
	  myBuffer.push('1');
	  myBuffer.push('2');
	  assert(myBuffer.pop() == '1');
	  assert(myBuffer.pop() == '2');
     }

     // Full buffer can't be written to
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.push('1');
	  assertThrown(myBuffer.push('2'),
		       "Full buffer should throw exception if new element pushed!");
     }


     // A read frees up capacity for another write
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.push('1');
	  assert(myBuffer.pop() == '1');
	  myBuffer.push('2');
	  assert(myBuffer.pop() == '2');
     }

     // Read position is maintained even across multiple writes
     {
	  auto myBuffer = new Buffer!(char)(3);
	  myBuffer.push('1');
	  myBuffer.push('2');
	  assert(myBuffer.pop() == '1');
	  myBuffer.push('3');
	  assert(myBuffer.pop() == '2');
	  assert(myBuffer.pop() == '3');
     }

     // Items cleared out of buffer can't be read
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.push('1');
	  myBuffer.clear();
	  assertThrown(myBuffer.pop(), "Empty buffer should throw exception if popped!");
     }

     // Clear frees up capacity for another write
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.push('1');
	  myBuffer.clear();
	  myBuffer.push('2');
	  assert(myBuffer.pop() == '2');
     }

     // Clear does nothing on empty buffer
     {
	  auto myBuffer = new Buffer!(char)(1);
	  myBuffer.clear();
	  myBuffer.push('1');
	  assert(myBuffer.pop() == '1');
     }

     // Overwrite acts like write on non-full buffer
     {
	  auto myBuffer = new Buffer!(char)(2);
	  myBuffer.push('1');
	  myBuffer.forcePush('2');
	  assert(myBuffer.pop() == '1');
	  assert(myBuffer.pop() == '2');
     }

     // Overwrite replaces the oldest item on full buffer
     {
	  auto myBuffer = new Buffer!(char)(2);
	  myBuffer.push('1');
	  myBuffer.push('2');
	  myBuffer.forcePush('3');
	  assert(myBuffer.pop() == '2');
	  assert(myBuffer.pop() == '3');
     }

     // Overwrite replaces the oldest item remaining in buffer following a read
     {
	  auto myBuffer = new Buffer!(char)(3);
	  myBuffer.push('1');
	  myBuffer.push('2');
	  myBuffer.push('3');
	  assert(myBuffer.pop() == '1');
	  myBuffer.push('4');
	  myBuffer.forcePush('5');
	  assert(myBuffer.pop() == '3');
	  assert(myBuffer.pop() == '4');
	  assert(myBuffer.pop() == '5');
     }

     // Initial clear does not affect wrapping around
     {
	  auto myBuffer = new Buffer!(char)(2);
	  myBuffer.clear();
	  myBuffer.push('1');
	  myBuffer.push('2');
	  myBuffer.forcePush('3');
	  myBuffer.forcePush('4');
	  assert(myBuffer.pop() == '3');
	  assert(myBuffer.pop() == '4');
	  assertThrown(myBuffer.pop(), "Empty buffer should throw exception if popped!");
     }

     static if (allTestsEnabled)
     {

     }

}
