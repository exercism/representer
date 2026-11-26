/**
  * Universidad de La Laguna
  * Escuela Superior de Ingeniería y Tecnología
  * Grado en Ingeniería Informática
  * Informática Básica 2022-2023
  *
  * @file robot_simulator.h
  * @author Isaac Dominguez Fajardo alu0101474960@ull.edu.es
  * @date Ene 02 2022
  * @brief Robot Simulator
  * @bug There are no known bugs
  * @see https://exercism.org/tracks/cpp/exercises/robot-simulator
  */

#include <iostream>   
#include <string>     
#include <utility> 

#if !defined(ROBOT_SIMULATOR_H)
#define ROBOT_SIMULATOR_H

namespace robot_simulator {
  /**
   * @brief Enumera los puntos cardinales.
   * 
   */
  enum class Bearing { 
  NORTH, 
  EAST,
  SOUTH, 
  WEST
};

/**
 * @brief Clase Robot
 * 
 */
class Robot {
 public:
  Robot(const std::pair<int, int> position = {0, 0}, const Bearing bearing = Bearing::NORTH) 
        : posicition_x_(position.first), posicition_y_(position.second), bearing_(bearing) {};
  Bearing get_bearing() const { return bearing_; }
  std::pair<int, int> get_position() const { return std::make_pair(posicition_x_, posicition_y_); }
  void turn_right();
  void turn_left();
  void advance();
  void execute_sequence(const std::string& sentence);
 private:
  int posicition_x_; 
  int posicition_y_; 
  enum Bearing bearing_;
};
}  // namespace robot_simulator

#endif // ROBOT_SIMULATOR_H