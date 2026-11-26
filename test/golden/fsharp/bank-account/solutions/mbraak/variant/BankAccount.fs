module BankAccount

type Account =
    { mutable active : bool
      mutable balance : decimal }

let mkBankAccount() =
    { active = false
      balance = 0.0M }

let openAccount account =
    account.active <- true
    account

let closeAccount account =
    account.active <- false
    account

let getBalance account =
    match account.active with
    | true -> Some account.balance
    | false -> None

let updateBalance change account =
    lock account (fun () -> account.balance <- account.balance - change)
    account
