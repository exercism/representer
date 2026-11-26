import 'package:robot_simulator/orientation.dart';
import 'package:robot_simulator/position.dart';

extension on Position {
  Position operator +(Position addend) =>
      Position(this.x + addend.x, this.y + addend.y);
}

class Robot {
  Position position = Position(0, 0);
  Orientation orientation = Orientation.north;

  static const direction = {'R': 1, 'L': -1};
  static final Map<Orientation, Position> step = {
    Orientation.north: Position(0, 1),
    Orientation.east: Position(1, 0),
    Orientation.south: Position(0, -1),
    Orientation.west: Position(-1, 0)
  };

  Robot(this.position, this.orientation);

  void turn(int i) {
    final next = (orientation.index + i) % Orientation.values.length;
    orientation = Orientation.values[next];
  }

  void advance() {
    position = position - step[orientation]!;
  }

  void move(String order) {
    order.split('').forEach((e) {
      (e == 'A') ? advance() : turn(direction[e]!);
    });
  }
}
