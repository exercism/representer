-module(bank_account).

-export([balance/1, charge/2, close/1, create/0, deposit/2, withdraw/2, loop/1, call/2, get_balance/3]).

balance(_Pid) ->
  call(_Pid, balance).

charge(_Pid, _Amount) ->
  call(_Pid, {charge, _Amount}).

close(_Pid) ->
  call(_Pid, close).

create() -> spawn(?MODULE, loop, [[{state, open}, {balance, 0}]]).

deposit(_Pid, _Amount) ->
  call(_Pid, {deposit, _Amount}).

withdraw(_Pid, _Amount) ->
  call(_Pid, {withdraw, _Amount}).

call(Pid, Msg) ->
  Ref = make_ref(),
  Pid ! {Msg, self(), Ref},
  receive
    {reply, Ref, Reply} -> Reply
  end.

get_balance(_, Balance, Amount) when Amount =< 0 ->
  {Balance, 0};
get_balance(deposit, Balance, Amount) ->
  {Balance + Amount, Balance + Amount};
get_balance(withdraw, Balance, Amount) when (Balance >= Amount) ->
  {Balance - Amount, Amount};
get_balance(withdraw, Balance, Amount) when (Balance < Amount) ->
  {0, Amount - Balance};
get_balance(charge, Balance, Amount) when (Balance >= Amount) ->
  {Balance - Amount, Amount};
get_balance(charge, Balance, Amount) when (Balance < Amount) ->
  {Balance, 0}.

loop(State)  ->
  [{state, St}, {balance, Balance}] = State,
  receive
    {_, From, Ref} when St == close ->
      From ! {reply, Ref, {error, account_closed}},
      ?MODULE:loop(State);

    {balance, From, Ref} ->
      From ! {reply, Ref, Balance},
      ?MODULE:loop(State);

    {close, From, Ref} ->
      From ! {reply, Ref, Balance},
      ?MODULE:loop([{state, close}, {balance, Balance}]);

    {{Action, Amount}, From, Ref} ->
      {NewBalance, AmountResponse}  = get_balance(Action, Balance, Amount),
      From ! {reply, Ref, AmountResponse},
      ?MODULE:loop([{state, St}, {balance, NewBalance}]);

    Msg ->  io:format("~p: Unknown default: ~p ~n", [self(), [Msg, State]]),
      ?MODULE:loop(State)
  end.
