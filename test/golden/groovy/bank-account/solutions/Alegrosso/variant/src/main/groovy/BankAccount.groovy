import groovy.transform.Synchronized
class BankAccount {

    private int balance 
    boolean isOpen
    

    // You cannot do any operations before you open the account.
    // An account opens with a balance of 0
    // You can reopen an account
    
   @Synchronized
    void open() {
        if(isOpen) throw new UnsupportedOperationException()
        balance = 0
        isOpen = true
    }

    // you cannot do any operations after you close the account
    @Synchronized
    void close() {
        if(!isOpen) throw new UnsupportedOperationException()
        balance = 0
        isOpen = false
    }

    // this should increment the balance
    // you cannot deposit into a closed account
    // you cannot deposit a negative amount 
    @Synchronized
    void deposit(int amount) {
        if(!isOpen) throw new UnsupportedOperationException()
        if(amount <= 0) throw new IllegalArgumentException()
        balance += amount
    }
    

    // this should decrement the balance
    // you cannot withdraw into a closed account
    // you cannot withdraw a negative amount 
    @Synchronized
    void withdraw(int amount) {
        if(!isOpen) throw new UnsupportedOperationException()
        if(amount < 0 || amount > balance) throw new IllegalArgumentException()
        balance -= amount
    }

    // returns the current balance
    @Synchronized
    int getBalance() {
        if(!isOpen) throw new UnsupportedOperationException()
        return balance
    }

}