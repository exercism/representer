// @ts-check

/**
 * Implement the classes etc. that are needed to solve the
 * exercise in this file. Do not forget to export the entities
 * you defined so they are available for the tests.
 */
export class Size {
  constructor(width = 80, height = 60) {
    this.width = width;
    this.height = height;
}

  resize(newWidth, newHeight) {
    this.width = newWidth;
    this.height = newHeight;
  }
}

export class Position {
  constructor(x = 0, y = 0) {
    this.x = x;
    this.y = y;
  }
  move(newX, newY) {
    this.x = newX;
    this.y = newY;
  }
}

export class ProgramWindow {
  constructor(screenSize, size, position) {
    this.screenSize = new Size(800, 600)
    this.size = new Size
    this.position = new Position
  }
  resize(newSize) {
    this.size.width = (newSize.width <= 1 ? 1 : (newSize.width >= this.screenSize.width ? (this.screenSize.width - this.position.x) : newSize.width));
    this.size.height = (newSize.height <= 1 ? 1 : (newSize.height >= this.screenSize.height ? (this.screenSize.height - this.position.y) : newSize.height));
  }
  move(newPosition) {
    this.position.x = newPosition.x <= 0 ? 0 : ((newPosition.x + this.size.width) > this.screenSize.width) ? ((this.screenSize.width - (newPosition.x + this.size.width)) + newPosition.x) : newPosition.x;
    this.position.y = newPosition.y <= 0 ? 0 : ((newPosition.y + this.size.height) > this.screenSize.height) ? ((this.screenSize.height - (newPosition.y + this.size.height)) + newPosition.y) : newPosition.y; 
  }
}
export function changeWindow(newWindow) {
    const newSize = new Size(400, 300)
    const newPosition= new Position(100,150)
    newWindow.resize(newSize)
    newWindow.move(newPosition)
  return newWindow
  }