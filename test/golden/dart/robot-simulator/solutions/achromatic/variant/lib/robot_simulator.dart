import 'package:robot_simulator/orientation.dart';
import 'package:robot_simulator/position.dart';

class Robot {
  Orientation orientation;
  Position position;

  Robot(this.position, this.orientation);

  void turnRight() {
    switch (orientation) {
      case Orientation.north:
        orientation = Orientation.east;
        break;
      case Orientation.south:
        orientation = Orientation.west;
        break;
      case Orientation.east:
        orientation = Orientation.south;
        break;
      case Orientation.west:
        orientation = Orientation.north;
        break;
      default:
        throw Exception('invalid orientation');
    }
  }

  void turnLeft() {
    switch (orientation) {
      case Orientation.north:
        orientation = Orientation.west;
        break;
      case Orientation.south:
        orientation = Orientation.east;
        break;
      case Orientation.east:
        orientation = Orientation.north;
        break;
      case Orientation.west:
        orientation = Orientation.south;
        break;
      default:
        throw Exception('invalid orientation');
    }
  }

  void advance() {
    switch (orientation) {
      case Orientation.north:
        position = Position(position.x, position.y + 1);
        break;
      case Orientation.south:
        position = Position(position.x, position.y + 1);
        break;
      case Orientation.east:
        position = Position(position.x + 1, position.y);
        break;
      case Orientation.west:
        position = Position(position.x - 1, position.y);
        break;
      default:
        throw Exception('invalid orientation');
    }
  }

  void move(String moveset) {
    moveset.split('').forEach((move) {
      switch (move) {
        case 'R':
          turnRight();
          break;
        case 'L':
          turnLeft();
          break;
        case 'A':
          advance();
          break;
        default:
          throw ArgumentError('no such move');
      }
    });
  }
}
