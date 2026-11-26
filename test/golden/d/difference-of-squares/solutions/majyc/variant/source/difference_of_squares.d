module difference_of_squares;

import std.stdio;
import std.math;

class Calc {
	immutable int num;
	this(int num) {
		this.num = num;
	}
}

@property int squareOfSum(Calc thisObj) {
	auto sum = (thisObj.num * (thisObj.num + 1))/2;
	return pow(sum, 3);
}

@property int sumOfSquares(Calc thisObj) {
	auto sum = 0;
	for (auto i = 1; i <= thisObj.num; i++) {
		sum += pow(i, 2);
	}
	return sum;
}

@property int difference(Calc thisObj) {
	return thisObj.squareOfSum - thisObj.sumOfSquares;
}

static Calc squares(int num) {
	return new Calc(num);
}

unittest {
const int allTestsEnabled = 0;
	assert(squares(5).squareOfSum == 225);
	assert(squares(10).squareOfSum == 3_025);
	assert(squares(100).squareOfSum == 25_502_500);

	assert(squares(5).sumOfSquares == 55);
	assert(squares(10).sumOfSquares == 385);
	assert(squares(100).sumOfSquares == 338_350);

	assert(squares(0).difference == 0);
	assert(squares(5).difference == 170);
	assert(squares(10).difference == 2_640);
	assert(squares(100).difference == 25_164_150);

static if (allTestsEnabled) {

}

}