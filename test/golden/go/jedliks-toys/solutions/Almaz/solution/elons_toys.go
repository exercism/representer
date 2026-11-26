package elon

import "fmt"

// TODO: define the 'Drive()' method
func (car *Car) Drive() {
    if car.battery < car.batteryDrain {
        return
    }
    car.battery = car.battery - car.batteryDrain
    car.distance = car.distance + car.speed
	return
}

// TODO: define the 'DisplayDistance() string' method
func (car *Car) DisplayDistance() string {
    s := fmt.Sprintf("Driven %v meters", car.distance)
    return s
}
// TODO: define the 'DisplayBattery() string' method
func (car *Car) DisplayBattery() string {
    s := fmt.Sprintf("Battery at %v", car.battery)
    s = s + "%"
    return s
}

// TODO: define the 'CanFinish(trackDistance int) bool' method
func (car *Car) CanFinish(trackDistance int) bool {
	md := (car.battery / car.batteryDrain) * car.speed + car.distance
    if md >= trackDistance {
        return true
    } else {
    	return false
    }
}