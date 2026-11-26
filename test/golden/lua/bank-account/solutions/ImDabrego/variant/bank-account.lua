local BankAccount = {}

function BankAccount:new()
  local account = {
    _balance = 0,
    _is_open = false,
    _lock = false
  }
  setmetatable(account, self)
  self.__index = self
  return account
end

function BankAccount:open()
  if self._is_open then
    error("Account already open")
  end
  self._is_open = true
  self._balance = 0
end

function BankAccount:close()
  if not self._is_open then
    error("Account not open")
  end
  self._is_open = false
end

function BankAccount:balance()
  if not self._is_open then
    error("Account not open")
  end
  return self._balance
end

function BankAccount:deposit(amount)
  if not self._is_open then
    error("Account not open")
  end
  if amount < 0 then
    error("Cannot deposit negative amount")
  end
  self._balance = self._balance + amount
end

function BankAccount:withdraw(amount)
  if not self._is_open then
    error("Account not open")
  end
  if amount <= 0 then
    error("Cannot withdraw negative amount")
  end
  if amount > self._balance then
    error("Insufficient balance")
  end
  self._balance = self._balance - amount
end

return BankAccount
