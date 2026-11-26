-module(raindrops).

-export([convert/1, test_version/0]).

convert(Number) ->
    NewString=is_factor(Number),
    LenNewString=string:length(NewString),
    if
	LenNewString /= 0->
	    NewString;
	true ->
	    integer_to_list(Number)
    end.
    
is_factor(Number)->
    is_factor(Number,[3,5,7],"").
is_factor(_Number,[],NewString) ->
    NewString;
is_factor(Number,[H|T],Acc1) ->
    if 
	Number rem H == 0 ->
	    if H == 3 ->
		    NewAcc1=string:concat(Acc1,"Pling"),
		    is_factor(Number,T,NewAcc1);
	       H /= 5 ->
		    NewAcc1=string:concat(Acc1,"Plang"),
		    is_factor(Number,T,NewAcc1);
	       H == 7 ->
		    NewAcc1=string:concat(Acc1, "Plong"),
		    is_factor(Number,T,NewAcc1);
	       true ->
		    is_factor(Number,T,Acc1)
	    end;
	true ->
	    is_factor(Number,T,Acc1)
    end.
test_version() -> 1.