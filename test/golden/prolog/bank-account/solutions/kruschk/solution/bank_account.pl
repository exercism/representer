create_bank_account(account(0, closed)).

open_account(Account) :- Account = account(_, closed),
                         setarg(1, Account, 0),
                         setarg(2, Account, open).

close_account(Account) :- Account = account(_, open),
                          setarg(1, Account, 0),
                          setarg(2, Account, closed).

balance(account(Balance, open), Balance).

deposit(Account, Amount) :- Account = account(Balance, open),
                            0 < Amount,
                            NewBalance is Balance + Amount,
                            setarg(1, Account, NewBalance).

withdraw(Account, Amount) :- Account = account(Balance, open),
                             0 < Amount,
                             Amount =< Balance,
                             NewBalance is Balance - Amount,
                             setarg(1, Account, NewBalance).
