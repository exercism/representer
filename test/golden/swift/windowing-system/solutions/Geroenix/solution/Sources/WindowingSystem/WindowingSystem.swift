// TODO: Define the Size struct
struct Size {
    var width = 80
    var height = 60

    mutating func resize(newWidth: Int, newHeight: Int) {
        width = newWidth
        height = newHeight
    }
}
// TODO: Define the Position struct
struct Position {
    var x = 0
    var y = 0

    mutating func moveTo(newX: Int, newY: Int) {
        x = newX
        y = newY
    }
}
// TODO: Define the Window class
class Window {
    var title = "New Window"
    let screenSize = Size(width: 800, height: 600)
    var size = Size()
    var position = Position()
    var contents: String? = nil

    init() {}

    init(title: String, contents: String?, size: Size = Size(), position: Position = Position()) {
        self.title = title
        self.contents = contents
        self.size = size
        self.position = position
    }

    func resize(to newSize: Size) {
        let newWidth  = max(min(newSize.width,  screenSize.width  - position.x), 1)
        let newHeight = max(min(newSize.height, screenSize.height - position.y), 1)
        size = Size(width: newWidth, height: newHeight)
    }

    func move(to newPosition: Position) {
        let newX = max(min(newPosition.x, screenSize.width - size.width), 0)
        let newY = max(min(newPosition.y, screenSize.height - size.height), 0)
        position = Position(x: newX, y: newY)
    }

    func update(title newTitle: String) {
        self.title = newTitle
    }

    func update(text newContents: String?) {
        self.contents = newContents
    }

    func display() -> String {
        let contentsLine = contents ?? "[This window intentionally left blank]"

        return "\(title)\nPosition: (\(position.x), \(position.y)), " +
                       "Size: (\(size.width) x \(size.height))\n\(contentsLine)\n"
    }
}