class BankAccount
  def initialize
    @balance = 0
    @is_open = false
  end

  def balance
    raise ArgumentError.new "Please open the account beforehand" unless @is_open

    @balance
  end

  def close
    raise ArgumentError.new "The account is already close" unless @is_open
  
    @is_open = false
  end

  def deposit(amount)
    raise ArgumentError.new "Please open the account beforehand" unless @is_open

    raise ArgumentError.new "Deposit amount could not be negative" if amount.negative?

    @balance += amount
  end

  def open
    raise ArgumentError.new "Account is already open" if @is_open
  
    @balance = 0
    @is_open = true
  end

  def withdraw(amount)
    raise ArgumentError.new "Please open the account beforehand" unless @is_open

    raise ArgumentError.new "Withdraw amount could not be negative" if amount.negative?

    if balance < amount
      raise ArgumentError.new "Balance is smaller than withdraw amount"
    end

    @balance -= amount
  end
end
