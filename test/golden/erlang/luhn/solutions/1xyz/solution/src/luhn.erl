-module(luhn).

-export([valid/1]).

valid(Value) -> 
	case filter(Value,[]) of
	[]->false;
	[_]->false;
	L-> sum(L) rem 10 ==0
	end.

filter([],Acc)->Acc;
filter([H|T],Acc) when H>=$0,H=<$9->filter(T,[H|Acc]);
filter([H|T],Acc) when H==$\s->filter(T,Acc);
filter(_,_)->[].

sum(Value)->
	{Sum,_}=lists:foldl(fun
			(E,{Sum,0})->
					{E-$0+Sum,1};
			(E,{Sum,1})->
					Num=(E-$0)*2,
					{if(Num>9)->Num-9;true->Num end+Sum,0}
			end,{0,0},Value), 
	Sum.
