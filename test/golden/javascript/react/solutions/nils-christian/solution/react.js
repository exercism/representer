export class InputCell {

  constructor(value) {
    this.value = value;
    this.temporaryValue = value;
    this.dependentCells = [];
  }

  setValue(value) {
    if (this.value !== value) {
      this.value = value;
      this.temporaryValue = value;

      for (let cell of this.dependentCells) {
        cell.update();
      }
      for (let cell of this.dependentCells) {
        cell.commitUpdate();
      }
    }
  }

  addDependentCell(cell) {
    this.dependentCells.push(cell);
  }

}

export class ComputeCell {

  constructor(inputCells, fn) {
    this.inputCells = inputCells;
    this.callbacks = [];
    this.dependentCells = [];
    this.computeFunction = fn;
    this.value = this.computeFunction(this.inputCells)
    this.temporaryValue = this.value;
    for (let inputCell of inputCells) {
      inputCell.addDependentCell(this);
    }
  }

  addCallback(cb) {
    if (!this.callbacks.includes(cb)) {
      this.callbacks.push(cb);
    }
  }

  removeCallback(cb) {
    const index = this.callbacks.indexOf(cb);
    if (index !== -1) {
      this.callbacks.splice(index , 1);
    }
  }

  addDependentCell(cell) {
    this.dependentCells.push(cell);
  }

  update() {
    this.temporaryValue = this.computeFunction(this.inputCells.map(cell => new InputCell(cell.temporaryValue)));
    for (let cell of this.dependentCells) {
      cell.update();
    }
  }

  commitUpdate() {
    if (this.temporaryValue !== this.value) {
      this.value = this.temporaryValue;
      for (let callback of this.callbacks) {
        callback.call(this);
      }
    }
    for (let cell of this.dependentCells) {
      cell.commitUpdate();
    }
  }

}

export class CallbackCell {

  constructor(fn) {
    this.callbackFn = fn;
    this.values = [];
  }

  call(cell) {
    const value = this.callbackFn(cell);
    this.values.push(value);
  }

}
