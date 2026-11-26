const MINUTES_IN_HOUR = 60;
const MINUTES_IN_DAY = 24 * MINUTES_IN_HOUR;

export class Clock {
	private time = 0;

	constructor(hour = 0, minute = 0) {
		const time = (hour * MINUTES_IN_HOUR + minute) % MINUTES_IN_DAY;
		this.time = time >= 0 ? time : time - MINUTES_IN_DAY;
	}

	public toString(): string {
		const hours = String(Math.trunc(this.time / 60)).padStart(2, "0");
		const mins = String(this.time % 60).padStart(2, "0");

		return `${hours}:${mins}`;
	}

	public plus(minutes: number): Clock {
		return new Clock(0, this.time + minutes);
	}

	public minus(minutes: number): Clock {
		return new Clock(0, this.time - minutes);
	}

	public equals(other: Clock): boolean {
		return this.time === other.time;
	}
}
