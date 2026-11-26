my class X::BankAccount::Closed is Exception {
    method message {'account not open'}
}

my class X::BankAccount::AlreadyOpen is Exception {
    method message {'account already open'}
}

my class X::BankAccount::AmountNotPositive is Exception {
    method message {'amount must be greater than 0'}
}

my class X::BankAccount::NoOverdraft is Exception {
    method message {'amount must be less than balance'}
}

class BankAccount {
    has $!balance = 0;
    has $!is-open = False;
    has $!lock    = Lock.new;

    #| Opens the account and resets balance to 0. 
    #| Throws X::BankAccount::AlreadyOpen if already open.
    method open {
        $!lock.protect: {
            die X::BankAccount::AlreadyOpen.new if $!is-open;
            $!is-open = True;
            $!balance = 0;
        }
    }

    #| Closes the account. Subsequent operations will fail.
    #| Throws X::BankAccount::Closed if not open.
    method close {
        $!lock.protect: {
            die X::BankAccount::Closed.new unless $!is-open;
            $!is-open = False;
        }
    }

    #| Returns current balance if account is open.
    #| Throws X::BankAccount::Closed if not open.
    method balance {
        $!lock.protect: {
            die X::BankAccount::Closed.new unless $!is-open;
            return $!balance;
        }
    }

    #| Withdraws money from the account.
    #| Validates that amount is positive, account is open, and funds are sufficient.
    method withdraw ($amount) {
        die X::BankAccount::AmountNotPositive.new if $amount <= 0;
        $!lock.protect: {
            die X::BankAccount::Closed.new unless $!is-open;
            die X::BankAccount::NoOverdraft.new if $amount > $!balance;
            $!balance -= $amount;
        }
    }

    #| Deposits money into the account.
    #| Validates that amount is positive and account is open.
    method deposit ($amount) {
        die X::BankAccount::AmountNotPositive.new if $amount <= 0;
        $!lock.protect: {
            die X::BankAccount::Closed.new unless $!is-open;
            $!balance += $amount;
        }
    }
}