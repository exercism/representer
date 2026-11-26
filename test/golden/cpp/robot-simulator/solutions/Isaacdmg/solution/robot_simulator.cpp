/**
  * Universidad de La Laguna
  * Escuela Superior de Ingeniería y Tecnología
  * Grado en Ingeniería Informática
  * Informática Básica 2022-2023
  *
  * @file robot_simulator.cpp
  * @author Isaac Dominguez Fajardo alu0101474960@ull.edu.es
  * @date Ene 02 2022
  * @brief Robot Simulator
  * @bug There are no known bugs
  * @see https://exercism.org/tracks/cpp/exercises/robot-simulator
  */

#include <iostream>
#include <string>
#include <stdexcept>

#include "robot_simulator.h"

namespace robot_simulator {
  /**
   * @brief Gira el robot a la derecha
   * 
   */
  void Robot::turn_right() {
    if (get_bearing() == Bearing::NORTH) {
      bearing_ = Bearing::EAST;
    } else if (get_bearing() == Bearing::EAST) {
      bearing_ = Bearing::SOUTH;
    } else if (get_bearing() == Bearing::SOUTH) {
      bearing_ = Bearing::WEST;
    } else {
      bearing_ = Bearing::NORTH;
    }
  }
  
  /**
   * @brief Gira el robot a la izquierda.
   * 
   */
  void Robot::turn_left() {
    if (get_bearing() == Bearing::NORTH) {
      bearing_ = Bearing::WEST;
    } else if (get_bearing() == Bearing::WEST) {
      bearing_ = Bearing::SOUTH;
    } else if (get_bearing() == Bearing::SOUTH) {
      bearing_ = Bearing::EAST;
    } else {
      bearing_ = Bearing::NORTH;
    }
  }
  
  /**
   * @brief Hace avanazar al raobot a la direccion que esta mirando.
   * 
   */
  void Robot::advance() {
    if (get_bearing() == Bearing::NORTH) {
      posicition_y_ += 1;
    } else if (get_bearing() == Bearing::SOUTH) {
      posicition_y_ -= 1;
    } else if (get_bearing() == Bearing::EAST) {
      posicition_x_+= 1;
    } else {
      posicition_x_-= 1;
    }
  }
  
  /**
   * @brief Ejecuta la secuencia pasada
   * 
   * @param sentence 
   */
  void Robot::execute_sequence(const std::string& sentence) {
    for (size_t i{0}; i < sentence.size(); ++i) {
      if (sentence[i] == 'R') {
        turn_right();
      } else if (sentence[i] == 'L') {
        turn_left();
      } else if (sentence[i] == 'A') {
        advance();
      }
    }
  }
}  // namespace robot_simulator
