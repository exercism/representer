// @ts-check

/**
 * Implement the classes etc. that are needed to solve the
 * exercise in this file. Do not forget to export the entities
 * you defined so they are available for the tests.
 */

export function Size(width = 80, height = 60) {
  this.width = width
  this.height = height
}

Size.prototype.resize = function(newWidth, newHeight) {
  this.width = newWidth;
  this.height = newHeight
}

export function Position(x = 0, y = 0) {
  this.x = x
  this.y = y
}

Position.prototype.move = function(newX, newY) {
  this.x = newX
  this.y = newY
}

export class ProgramWindow {
  constructor() {
    this.screenSize = new Size(800, 600)
    this.size = new Size()
    this.position = new Position()
  }

  resize(newSize) {
    this.size.width = newSize.width < 1 ? 1 : newSize.width
    this.size.height = newSize.height < 1 ? 1 : newSize.height
    if (this.position.x + this.size.width > this.screenSize.width) {
      this.size.width = this.screenSize.width - this.position.x;
    }
    if (this.position.y + this.size.height > this.screenSize.height) {
      this.size.height = this.screenSize.height - this.position.y;
    }
  }

  move(newPosition) {
      this.position.x = newPosition.x < 0 ? 0 : newPosition.x
    this.position.y = newPosition.y < 0 ? 0 : newPosition.y
    if (this.position.x + this.size.width > this.screenSize.width) {
      this.position.x = this.screenSize.width - this.size.width;
    }
    if (this.position.y + this.size.height > this.screenSize.height) {
      this.position.y = this.screenSize.height - this.size.height;
    }
    
    
    
    
    
  }
}

export const changeWindow = function(programWindow) {
  programWindow.size.width = 400
    programWindow.size.height = 300
  programWindow.position.x = 100
    programWindow.position.y = 150

  return programWindow
}