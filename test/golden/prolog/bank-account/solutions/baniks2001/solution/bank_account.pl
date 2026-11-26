:- dynamic account/3.

create_bank_account(AccountId) :-
    gensym(account_, AccountId),
    assert(account(AccountId, 0, closed)).

open_account(AccountId) :-
    with_mutex(AccountId, (
        account(AccountId, _, Status),
        (Status == closed ->
            retract(account(AccountId, _, _)),
            assert(account(AccountId, 0, open))
        ;
            fail  % Already open
        )
    )).

close_account(AccountId) :-
    with_mutex(AccountId, (
        account(AccountId, _, Status),
        (Status == open ->
            retract(account(AccountId, _, _)),
            assert(account(AccountId, 0, closed))
        ;
            fail  % Already closed or doesn't exist
        )
    )).

balance(AccountId, Balance) :-
    account(AccountId, Balance, open).

deposit(AccountId, Amount) :-
    Amount > 0,
    with_mutex(AccountId, (
        account(AccountId, CurrentBalance, open),
        NewBalance is CurrentBalance + Amount,
        retract(account(AccountId, _, _)),
        assert(account(AccountId, NewBalance, open))
    )).

withdraw(AccountId, Amount) :-
    Amount > 0,
    with_mutex(AccountId, (
        account(AccountId, CurrentBalance, open),
        CurrentBalance >= Amount,
        NewBalance is CurrentBalance - Amount,
        retract(account(AccountId, _, _)),
        assert(account(AccountId, NewBalance, open))
    )).