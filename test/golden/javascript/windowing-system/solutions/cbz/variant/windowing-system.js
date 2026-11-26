// @ts-check

/**
 * Implement the classes etc. that are needed to solve the
 * exercise in this file. Do not forget to export the entities
 * you defined so they are available for the tests.
 */
export function Size(width = 80, height = 60) {
  this.width = width;
  this.height = height;
}

Size.prototype.resize = function (newWidth, newHeight) {
  this.width = newWidth;
  this.height = newHeight;
};

export function Position(x = 0, y = 0) {
  this.x = x;
  this.y = y;
}

Position.prototype.move = function(newX, newY) {
  this.x = newX;
  this.y = newY;
}

export class ProgramWindow {
  constructor() {
    this.screenSize = new Size(800, 600);
    this.size = new Size();
    this.position = new Position();
  }
  resize(newSize) {
    const width = newSize.width > 0 ? newSize.width : 1;
    const height = newSize.height > 0 ? newSize.height : 1;

    this.size.width = Math.min(width, this.screenSize.width - this.position.x);
    this.size.height = Math.min(height, this.screenSize.height - this.position.y);
  }
  
  move(newPosition) {
    const x = newPosition.x > 0 ? newPosition.x : 0;
    const y = newPosition.y >= 0 ? newPosition.y : 0;
    
    this.position.x = Math.min(x, this.screenSize.width - this.size.width);
    this.position.y = Math.min(y, this.screenSize.height - this.size.height);
  }
}

export function changeWindow(window) {
  const zeroPosition = new Position(0, 0);
  const newPosition = new Position(100, 150);
  const newSize = new Size(400, 300);

  window.move(zeroPosition);
  window.resize(newSize);
  window.move(newPosition);
  return window;
}