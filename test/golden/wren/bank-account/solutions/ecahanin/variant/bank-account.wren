class BankAccount {
  construct new() {
    _bal = 0
    _open = false
  }

  open() {
    if (_open) Fiber.abort("Bank account error")
    _open = true
    _bal = 0
  }

  close() {
    if (!_open) Fiber.abort("Bank account error")
    _open = false
  }

  deposit(amount) {
    if (!_open || amount < 0) Fiber.abort("Bank account error")
    _bal = _bal + amount
    
  }

  withdraw(amount) {
    if (!_open && amount > _bal || amount < 0) Fiber.abort("Bank account error")
    _bal = _bal - amount
  }

  balance {
    if (!_open) Fiber.abort("Bank account error")
    return _bal 
    
  }
}
