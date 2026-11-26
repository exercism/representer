export class Matrix {
  private _rows: number[][]

  constructor(data: string) {
    this._rows = data.split('\n').map(r => r.split(' ').map(Number))
  }

  get rows() {
    return this._rows
  }

  get columns() {
    const data = [...this._rows]
    const startArray = [...Array(this._rows[0].length).keys()].map(() => [] as number[])

    return data.reduce(
      (prev, row) => {

        row.forEach((value, colIndex) => {
          prev[colIndex].push(value)
        })

        return prev

      }, startArray
    )
  }
}
