export class Gigasecond {
  dateInSeconds: number;
  _dateAfterGigasecond: number;
  constructor(date: Date) {
    this.dateInSeconds = date.getTime();
    this._dateAfterGigasecond = this.dateAfterGigaSecond(this.dateInSeconds);   
  }
  dateAfterGigaSecond = (dateInSeconds: number): number => {
    return (dateInSeconds += 1000000000000);
  };
  public date(): Date {
    return new Date(this._dateAfterGigasecond);
  }
}