export class InputCell {
  constructor(value) {
    this._value = value;
    this.children = [];
  }
  get value() {
    return this._value;
  }
  setValue(value) {
    this._value = value;
    for (const cell of this.children) {
      cell.update();
    }
  }
}
export class ComputeCell {
  constructor(inputCells, fn) {
    this._inputCells = inputCells;
    this._fn = fn;
    this.children = [];
    this._callbacks = new Map();
    for (const cell of inputCells) {
      cell.children.push(this);
    }
    this._value = this.value;
  }
  get value() {
    this._value = this._fn(this._inputCells);
    return this._value;
  }
  // Update value and propagate change up cells.
  update() {
    if (!(this._value !== this.value)) {
      return;
    }
    for (const key of this._callbacks.keys()) {
      this._callbacks.get(key).newValue(this);
    }
    for (const cell of this.children) {
      cell.update();
    }
  }
  addCallback(cbCell) {
    this._callbacks.set(cbCell.id, cbCell);
  }
  removeCallback(cbCell) {
    const key = cbCell.id;
    this._callbacks.delete(key);
  }
}
export class CallbackCell {
  constructor(fn) {
    this.id = ++CallbackCell.prototype.id;
    this.values = [];
    this.fn = fn;
  }
  newValue(cell) {
    this.values.push(this.fn(cell));
  }
}
CallbackCell.prototype.id = 0;