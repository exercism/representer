export class Clock {
  totalMinutes: number;
  constructor(hour: number, minute?: number) {    
    this.totalMinutes = ((hour * 60) + (minute ?? 0)) % 1440;
    if(this.totalMinutes < 0){
      this.totalMinutes += 1440
    }
  }

  public toString(): string {
    let hours = this.totalMinutes >= 60 ? Math.floor(this.totalMinutes / 60): 0;
    if(hours >= 24){
      hours %= 24;
    }
  
    let minutes = this.totalMinutes;
    if(minutes >= 60){
      minutes %= 60;
    }
    return `${hours  < 10 ? `0${hours}` : hours.toString()}:${minutes  < 10 ? `0${minutes}` : minutes.toString()}`
  }

  public plus(minutes: number): Clock {
    const newClockMinutes = this.totalMinutes + minutes;
    return new Clock(0 ,newClockMinutes);
  }

  public minus(minutes: number): Clock {
        const newClockMinutes = this.totalMinutes - minutes;
    return new Clock(0, newClockMinutes);
  }

  public equals(other: Clock): boolean {
    return this.toString() == other.toString();
  }
}
