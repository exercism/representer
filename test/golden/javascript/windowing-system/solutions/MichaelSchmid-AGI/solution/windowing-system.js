// @ts-check
export class Size{
  constructor(w=80,h=60){
    this.width=w
    this.height=h
  }
  resize(w,h){
    this.width=w
    this.height=h
  }
}
export class Position{
  constructor(x=0,y=0){
    this.x=x
    this.y=y
  }
  move(x,y){
    this.x=x
    this.y=y
  }
}

export class ProgramWindow{
  constructor(){
      this.screenSize= new Size(800,600);
      this.size =new Size()
      this.position = new Position
  }
  resize(Size){
    if(Size.width <1){Size.width=1}
    if(Size.height <1){Size.height=1}
    if(this.screenSize.width<this.position.x+Size.width){Size.width=this.screenSize.width-this.position.x}
    if(this.screenSize.height<this.position.y+Size.height){Size.height=this.screenSize.height-this.position.y}
      this.size.resize(Size.width,Size.height)
  }
  move(Position){
    if(Position.x <0){Position.x=0}
    if(Position.y <0){Position.y=0}
    if(Position.x+ this.size.width>this.screenSize.width){Position.x=this.screenSize.width-this.size.width}
    if(Position.y+ this.size.height>this.screenSize.height){Position.y=this.screenSize.height-this.size.height}
    this.position.move(Position.x,Position.y)
  }
}
export function changeWindow(programWindow) {
  programWindow.size=new Size(400,300)
  programWindow.position=new Position(100,150)
  return programWindow
}
  
