// Same clock with every name changed, other quotes, semicolons and layout.
export class Timer {
  private h!: number;
  private m!: number;

  constructor(h: number, m: number = 0) {
    this.restart();
    const total = h * 60 + m;
    this.moveBy(total);
  }

  private restart(): void {
    this.h = 0;
    this.m = 0;
  }

  public getHour(): number { return this.h; }

  public getMinute(): number { return this.m; }

  public toString(): string {
    return `${this.pad(this.h)}:${this.pad(this.m)}`;
  }

  private pad(value: number): string {
    const text = value.toString();
    return text.length === 1 ? `0${text}` : text;
  }

  public plus(amount: number): Timer {
    this.moveBy(amount);
    return this;
  }

  public minus(amount: number): Timer {
    this.moveBy(-1 * amount);
    return this;
  }

  public equals(other: Timer): boolean {
    return this.h === other.getHour() && this.m === other.getMinute();
  }

  private moveBy(change: number): void {
    const perDay = 1440;
    const perHour = 60;
    const hoursInDay = 24;

    change = Math.abs(change) >= perDay ? change % perDay : change;

    const current = this.h * perHour + this.m;
    let later = (current + change) % perDay;

    later = later < 0 ? (later += perDay) : later;

    this.h = Math.floor(later / perHour) % hoursInDay;
    this.m = later - this.h * perHour;
  }
}
