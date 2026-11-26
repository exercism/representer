export class InputCell {
  constructor(value) {
    this.val = value;
    this.children = [];
  }

  get value() {
    return this.val;
  }

  setValue(value) {
    this.val = value;
    for (const cell of this.children) {
      cell.update();
    }
  }
}

export class ComputeCell {
  constructor(inputCells, fn) {
    this.cells = inputCells;
    this.func = fn;
    this.children = [];
    this.call = new Map();
    for (const cell of inputCells) {
      cell.children.push(this);
    }
    this.val = this.value;
  }

  get value() {
    this.val = this.func(this.cells);
    return this.val;
  }

  update() {
    if (!(this.val !== this.value)) {
      return;
    }
    for (const key of this.call.keys()) {
      this.call.get(key).newValue(this);
    }
    for (const cell of this.children) {
      cell.update();
    }
  }

  addCallback(cbCell) {
    this.call.set(cbCell.id, cbCell);
  }

  removeCallback(cbCell) {
    const key = cbCell.id;
    this.call.delete(key);
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