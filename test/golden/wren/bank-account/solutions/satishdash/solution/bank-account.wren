class BankAccount {
  construct new() {
    _isActive = false
    _balance = 0
  }

  open() {
    if (_isActive) {
      Fiber.abort("Bank account error")
    } else {
      _isActive = true
      _balance = 0
    }
  }

  close() {
    if (_isActive) {
      _isActive = false
      _balance = 0
    } else {
      Fiber.abort("Bank account error")
    }
  }

  deposit(amount) {
    if (_isActive && amount > 0) {
      _balance = _balance + amount
    } else {
      Fiber.abort("Bank account error")
    }
  }

  withdraw(amount) {
    if (_isActive && amount > 0 && amount <= _balance) {
      _balance = _balance - amount
    } else {
      Fiber.abort("Bank account error")
    }
  }

  balance {
    return _isActive ? _balance : Fiber.abort("Bank account error")
  }
}
