class BankAccount
  new: =>
    @_open = false
    @_balance = 0

  open: =>
    assert not @_open, 'account already open'
    @_open = true

  close: =>
    assert @_open, 'account not open'
    @_open = false
    @_balance = 0

  balance: =>
    assert @_open, 'account not open'
    @_balance

  deposit: (amount) =>
    assert @_open, 'account not open'
    assert amount > 0, 'amount must be greater than 0'
    @_balance += amount

  withdraw: (amount) =>
    assert @_open, 'account not open'
    assert amount >= 0, 'amount must be greater than 0'
    assert @_balance >= amount, 'amount must be less than balance'
    @_balance -= amount
