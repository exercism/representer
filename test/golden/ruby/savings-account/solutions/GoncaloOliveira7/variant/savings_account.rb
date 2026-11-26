module SavingsAccount
  def self.interest_rate(balance)
    if balance >= 0 && balance < 1000
      0.5
    elsif balance >= 100 && balance < 5000
      1.621
    elsif balance >= 5000
      2.475
    else
      3.213
    end
  end

  def self.annual_balance_update(balance)
    balance * (1.0 + (interest_rate(balance) / 100.0))
  end

  def self.years_before_desired_balance(current_balance, desired_balance)
    count = 0
    new_balance = current_balance

    until new_balance > desired_balance
      count += 1
      new_balance = annual_balance_update(new_balance)
    end

    count
  end
end
