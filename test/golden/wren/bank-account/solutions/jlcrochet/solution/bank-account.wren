class BankAccount {
    construct new() {
        _balance = 0
        _locked = true
    }

    open() {
        if (_locked) {
            _locked = false
            _balance = 0
        } else {
            Fiber.abort("Bank account error")
        }
    }

    close() {
        if (_locked) {
            Fiber.abort("Bank account error")
        } else {
            _locked = true
        }
    }

    deposit(amount) {
        if (_locked || amount < 0) {
            Fiber.abort("Bank account error")
        } else {
            _balance = _balance + amount
        }
    }

    withdraw(amount) {
        if (_locked || amount < 0 || amount > _balance) {
            Fiber.abort("Bank account error")
        } else {
            _balance = _balance - amount
        }
    }

    balance {
        if (_locked) Fiber.abort("Bank account error")
        return _balance
    }
}
