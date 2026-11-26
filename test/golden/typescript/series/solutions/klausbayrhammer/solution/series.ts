export class Series {
    private series: number[];

    constructor(series: string) {
        this.series = series.split('').map(Number);
    }

    slices(sliceLength: number): number[][] {
        this.validateSlices(sliceLength);
        const numberOfSlices = this.series.length + 1 - sliceLength;
        return [...Array(numberOfSlices).keys()]
            .map(i => this.series.slice(i, i + sliceLength))
    }

    private validateSlices(sliceLength: number): void {
        if (this.series.length === 0) {
            throw new Error('series cannot be empty')
        }
        if (sliceLength < 0) {
            throw new Error('slice length cannot be negative')
        }
        if (sliceLength === 0) {
            throw new Error('slice length cannot be zero')
        }
        if (sliceLength > this.series.length) {
            throw new Error('slice length cannot be greater than series length')
        }
    }
}
