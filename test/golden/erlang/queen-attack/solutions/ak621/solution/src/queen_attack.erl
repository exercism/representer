-module(queen_attack).

-export([can_attack/2]).


can_attack(WhiteQueen, BlackQueen) -> 
    {Wx, Wy} = WhiteQueen,
    {Bx, By} = BlackQueen,

	case {abs(Wx-Bx), abs(Wy-By)} of
		{_X, _X} -> true;
		{ 0, _ } -> true;
		{ _, 0 } -> true;
			  _  -> false
	end.
