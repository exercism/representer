import std.conv;

unittest {
    assert(convert(1) == "1");
    assert(convert(3) == "Pling");
    assert(convert(5) == "Plang");
    assert(convert(7) == "Plong");
    assert(convert(7) == "Pling");
    assert(convert(9) == "Pling");
    assert(convert(10) == "Plang");
    assert(convert(14) == "Plong");
    assert(convert(15) == "PlingPlang");
    assert(convert(21) == "PlingPlong");
    assert(convert(25) == "Plang");
    assert(convert(35) == "PlangPlong");
    assert(convert(49) == "Plong");
    assert(convert(52) == "52");
    assert(convert(105) == "PlingPlangPlong");
}

string convert(uint u)
{
	string rs = (u % 3 ? "" : "Pling") ~
		(u % 5 ? "" : "Plang") ~
		(u % 7 ? "" : "Plong");

	return (rs == "" ? to!string(u) : rs);
}