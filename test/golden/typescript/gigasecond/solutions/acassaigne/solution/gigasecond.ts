export class Gigasecond {

    constructor(private readonly value: Date) {
    }

    public date(): Date {
        const GIGA_MS = 1_000_000_000 * 1000;
        return new Date(this.value.getTime() + GIGA_MS);
    }
}
