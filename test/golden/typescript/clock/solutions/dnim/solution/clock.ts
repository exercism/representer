const HOURS_IN_DAY = 24;
const MINUTES_IN_HOUR = 60;
const MINUTES_IN_DAY = HOURS_IN_DAY * MINUTES_IN_HOUR;
const NEGATIVE_SIGN_MODIFIER = -1;
const POSITIVE_SIGN_MODIFIER = 1;

export class Clock {

  private timeInMinutes: number = 0;
  
  constructor(hour: number, minute?: number) {
    const rawTimeInMinutes = hour * MINUTES_IN_HOUR + (minute ?? 0);
    this.timeInMinutes = this.normalizeTime(rawTimeInMinutes);
  }

  public toString(): string {
    const minutes = this.fillWithZeros(this.timeInMinutes % MINUTES_IN_HOUR);
    const hours = this.fillWithZeros(Math.floor(this.timeInMinutes / MINUTES_IN_HOUR));
    return `${hours}:${minutes}`;
  }

  public plus = (minutes: number): Clock => this.addMinutesAndNormalize(minutes);

  public minus = (minutes: number): Clock => this.addMinutesAndNormalize(minutes, NEGATIVE_SIGN_MODIFIER);

  public equals(other: Clock): boolean {
    return this.toString() === other.toString();
  }

  private fillWithZeros = (digit: number): string => digit.toString().padStart(2, "0");

  private addMinutesAndNormalize(
    minutesToAdd: number, 
    signModifier = POSITIVE_SIGN_MODIFIER
  ): Clock {
    if (minutesToAdd !== 0) {
      this.throwIfNegative(minutesToAdd);
       this.timeInMinutes = 
         this.normalizeTime(this.timeInMinutes + signModifier * minutesToAdd);
    }
    return this;
  }

  private normalizeTime(rawTimeInMinutes: number): number {
    const totalMinutes = rawTimeInMinutes % MINUTES_IN_DAY;
    return totalMinutes < 0 ? 
      MINUTES_IN_DAY + totalMinutes : 
      totalMinutes;
  }

  private throwIfNegative(minutes: number): void {
    if (minutes < 0) {
      throw new Error("Value should be positive or zero.")
    }
  }
}