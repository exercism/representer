-module(crypto_square).
-export([ciphertext/1]).
ciphertext([]) ->
    [];
ciphertext(PlainText) -> 
    SimpleText = normalize(PlainText),
    Size = length(SimpleText),
    C = ceil(math:sqrt(Size)),
    encode(SimpleText, C).
normalize(Text) ->
    Separators = "\',.$\t$\n !@%",
    NewText = [A || A <- Text, not lists:member(A, Separators)],
    string:casefold(NewText).
encode(SimpleText, 0) ->
    SimpleText;
encode(SimpleText, C) ->
    Res = encode(SimpleText, C, 0, #{}),
    Fun = fun(K, V, AccIn) -> 
        case K + 1 of
            C ->
                AccIn ++ lists:reverse(V);
            _ ->
                AccIn ++ lists:reverse([32| V])
        end
    end,
    maps:fold(Fun, [], Res).
encode([], C, Counter, Acc) ->
    I = Counter rem C,
    if
        I > 0 ->
            List = maps:get(I, Acc, []),
            NewList = [32|List],
            NewAcc = maps:put(I, NewList, Acc),
            encode([], C, Counter + 1, NewAcc);
        true ->
            Acc
    end;
encode([H|T], C, Counter, Acc) ->
    I = Counter rem C,
    List = maps:get(I, Acc, []),
    NewList = [H|List],
    NewAcc = maps:put(I, NewList, Acc),
    encode(T, C, Counter + 1, NewAcc).