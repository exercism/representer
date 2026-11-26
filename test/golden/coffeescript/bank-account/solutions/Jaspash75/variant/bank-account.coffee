class BankAccount

  constructor: ->
    @opened = false
    @currentBalance = 0

  checkOpen: ->
    throw "account not open" unless @opened

  open: ->
    throw "account already open" if @opened
    @opened = true
    @currentBalance = 0

  close: ->
    @checkOpen()
    @opened = false
    @currentBalance = 0

  balance: ->
    @checkOpen()
    @currentBalance

  deposit: (amount) ->
    @checkOpen()
    throw "amount must be greater than 0" if amount < 0
    @currentBalance += amount

  withdraw: (amount) ->
    @checkOpen()
    throw "amount must be greater than 0" if amount <= 0
    throw "amount must be less than balance" if amount > @currentBalance
    @currentBalance -= amount

module.exports = BankAccount