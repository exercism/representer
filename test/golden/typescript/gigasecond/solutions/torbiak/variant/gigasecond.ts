export class Gigasecond {
  private milliseconds: number;

  constructor(date: Date) {
    this.milliseconds = date.getTime() - 10 ** 12;
  }

  public date(): Date {
    return new Date(this.milliseconds);
  }
}
