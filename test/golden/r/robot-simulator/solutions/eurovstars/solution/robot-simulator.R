new_robot <- function(coordinates, direction) {
  robot <- list(
    coordinates = coordinates,
    direction = direction
  )
  class(robot) <- "robot"
  robot
}

move <- function(a_robot, commands) {
  UseMethod("move")
}

move.robot <- function(a_robot, commands) {
  coordinates <- a_robot$coordinates
  direction <- a_robot$direction
  movement_set <- strsplit(commands, split = "")[[1]]
  for (i in movement_set) {
    if (direction == "NORTH" && i == "A") {
      coordinates[2] <- coordinates[2] + 1
    } else if (direction == "NORTH" && i == "R") {
      direction <- "EAST"
    } else if (direction == "NORTH" && i == "L") {
      direction <- "WEST"
    } else if (direction == "EAST" && i == "A") {
      coordinates[1] <- coordinates[1] + 1
    } else if (direction == "EAST" && i == "R") {
      direction <- "SOUTH"
    } else if (direction == "EAST" && i == "L") {
      direction <- "NORTH"
    } else if (direction == "SOUTH" && i == "A") {
      coordinates[2] <- coordinates[2] - 1
    } else if (direction == "SOUTH" && i == "R") {
      direction <- "WEST"
    } else if (direction == "SOUTH" && i == "L") {
      direction <- "EAST"
    } else if (direction == "WEST" && i == "A") {
      coordinates[1] <- coordinates[1] - 1
    } else if (direction == "WEST" && i == "R") {
      direction <- "NORTH"
    } else if (direction == "WEST" && i == "L") {
      direction <- "SOUTH"
    }
  }
  a_robot$coordinates <- coordinates
  a_robot$direction <- direction
  a_robot
}
