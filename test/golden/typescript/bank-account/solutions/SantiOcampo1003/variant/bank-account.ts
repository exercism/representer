export class ValueError extends Error {
  constructor(message: string = 'Bank account error') {
    super(message);
    this.name = "ValueError";
  }
}

export class BankAccount {
  private _isOpen: boolean;
  private _balance: number;

  constructor() {
    this._isOpen = false;
    this._balance = 0;
  }

  public open(): void {
    if (this._isOpen) throw new ValueError("Account is already open");
    this._isOpen = true;
  }

  public close(): void {
    if (!this._isOpen) throw new ValueError("Account is already closed");
    this._isOpen = false;
    this._balance = 0;
  }

  public deposit(amount: number): void {
    if (!this._isOpen) throw new ValueError("Account is closed");
    if (amount < 0) throw new ValueError("Cannot deposit negative amount");
    this._balance += amount;
  }

  public withdraw(amount: number): void {
    if (!this._isOpen) throw new ValueError("Account is closed");
    if (amount <= 0) throw new ValueError("Cannot withdraw negative amount");
    if (amount > this._balance) throw new ValueError("Insufficient funds");
    this._balance -= amount;
  }

  public get balance(): number {
    if (!this._isOpen) throw new ValueError("Account is closed");
    return this._balance;
  }
}

