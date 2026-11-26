// @ts-check

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

Position.prototype.move = function (x, y) {
  this.x = x;
  this.y = y;
};


export class ProgramWindow {
  screenSize;
  size;
  position;
  
  constructor() {
    this.screenSize = { width: 800, height: 600 };
    this.size = new Size();
    this.position = new Position();
  }

  set size(value) {
    this.size = value;
  }

  resize(newSize) {
    if (newSize.width < 1) { newSize.width = 1 };
    if (newSize.width + this.position.x > this.screenSize.width) {
      newSize.width = this.screenSize.width - this.position.x
    };
    if (newSize.height < 1) { newSize.height = 1 };
    if (newSize.height + this.position.y > this.screenSize.height) {
      newSize.height = this.screenSize.height - this.position.y
    };
    this.size = newSize;
  }

  move(newPosition) {
    if (newPosition.x < 0) { newPosition.x = 0 };
    if (newPosition.x + this.size.width > this.screenSize.width) {
      newPosition.x = this.screenSize.width - this.size.width;
    };
    if (newPosition.y < 0) { newPosition.y = 0 };
    if (newPosition.y + this.size.height > this.screenSize.height) {
      newPosition.y = this.screenSize.height - this.size.height;
    };
    this.position = newPosition;
  }
}

export function changeWindow(newWindow) {
  newWindow.size = new Size(400, 300);
  newWindow.position = new Position(100, 150);
  return newWindow;
}
