module BankAccount

// https://en.wikibooks.org/wiki/F_Sharp_Programming/MailboxProcessor

type Message = 
| OpenAccount
| CloseAccount
| GetBalance of AsyncReplyChannel<decimal option>
| UpdateBalance of decimal

type Account = MailboxProcessor<Message>

let processor (account:Account) = 
    let rec loop balance = async { 
        let! msg = account.Receive()
        match msg with
        | OpenAccount           -> return! loop (Some 0.0m)
        | CloseAccount          -> return! loop None
        | GetBalance channel    -> channel.Reply balance; return! loop balance
        | UpdateBalance change  -> return! loop (balance |> Option.map ((+) change))
    }
    loop

let mkBankAccount() = MailboxProcessor.Start(fun account -> processor account None)

let openAccount     (account : Account)         = account.Post OpenAccount; account
let closeAccount    (account : Account)         = account.Post CloseAccount; account
let getBalance      (account : Account)         = account.PostAndReply GetBalance
let updateBalance   change (account : Account)  = account.Post (UpdateBalance change); account

