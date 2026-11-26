module BankAccount

type msg =
    | Update of decimal
    | Open
    | Close
    | Fetch of AsyncReplyChannel<decimal option>

type BnkAccount() =
    let updateState bal msg =
        match msg with
        | Update change -> Option.map ((+) change) bal
        | Open -> Some 0m
        | Close -> None
        | Fetch (replyChannel) ->
            replyChannel.Reply(bal)
            bal

    let accountAgent =
        MailboxProcessor.Start(fun inbox ->
            let rec messageLoop bal =
                async {
                    let! msg = inbox.Receive()
                    let state = updateState bal msg
                    return! messageLoop state
                }

            messageLoop (None))

    member this.UpdateBalance change = accountAgent.Post(Update change)
    member this.Open() = accountAgent.Post Open
    member this.Close() = accountAgent.Post Close
    member this.Get() = accountAgent.PostAndReply(Fetch)

let mkBankAccount () = new BnkAccount()

let andThen item (_: unit) = item
let openAccount (account: BnkAccount) = account.Open() |> andThen account
let closeAccount (account: BnkAccount) = account.Close() |> andThen account
let getBalance (account: BnkAccount) = account.Get()

let updateBalance change (account: BnkAccount) =
    account.UpdateBalance change |> andThen account
