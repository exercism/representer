export class ValueError extends Error {
  constructor() {
    super('Bank account error')
  }
}

export class BankAccount {
  private accountBalance: number | null = null;

  // Because operations can be initiated from multiple sources, we push values to arrays and iterate over them in order to avoid race conditions as stated in the Instructions.
  private depositTransactions: number[] = [];
  private withdrawTransactions: number[] = [];
  
  constructor() {}

  open(): void {
    if(this.accountBalance === 0) throw new ValueError();
    this.accountBalance = 0;
  }

  close(): void {
    if(this.accountBalance === null) throw new ValueError();
    this.accountBalance = null;
  }

  deposit(value: number): void {
    if(
      this.accountBalance === null ||
      value <= 0
    ) throw new ValueError();
    this.depositTransactions.push(value);
    while(this.depositTransactions.length > 0) {
      this.accountBalance += this.depositTransactions.shift() as number;
    }
  }

  withdraw(value: number): void {
    if(
      this.accountBalance === null ||
      value > this.accountBalance ||
      value <= 0
    ) throw new ValueError();
    
    this.withdrawTransactions.push(value);
    while(this.withdrawTransactions.length > 0) {
      this.accountBalance -= this.withdrawTransactions.shift() as number;
    }
  }

  get balance(): number {
    if(this.accountBalance !== null) throw new ValueError();
    return this.accountBalance;
  }
}
