class RobotName {

    String name

def charList = ('A'..'Z').toList()

    
    RobotName() {
        name = [charList[(Math.random()*25) + 1 as int],charList[(Math.random()*25) - 1 as int], Math.random()*999 as int].join()
        //reset = new RobotName().name
    }
    def reset() {
        name = new RobotName().name
    }
}