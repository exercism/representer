package speed

// TODO: define the 'Car' type struct
type Car struct {
	battery      int
	batteryDrain int
	speed        int
	distance     int
}
type Track struct {
	distance int
}
// NewCar creates a new remote controlled car with full battery and given specifications.
func NewCar(speed, batteryDrain int) Car {
	return Car{
		speed:        speed,
		batteryDrain: batteryDrain,
		battery:      100,
        distance: 0,

		//panic("Please implement the NewCar function")
	}
}

// TODO: define the 'Track' type struct


// NewTrack creates a new track
func NewTrack(distance int) Track {
	return Track{
		distance: distance,
	}
	//panic("Please implement the NewTrack function")
}

// Drive drives the car one time. If there is not enough battery to drive one more time,
// the car will not move.

//Add a new field to keep track of the distance driven
//You need to check if there is enough battery to drive the car
func Drive(car Car) Car {
	if car.battery >=car.batteryDrain{
		car.battery -= car.batteryDrain
		car.distance += car.speed
        return car}
    return car
	 
	//panic("Please implement the Drive function")
}

func CanFinish(car Car, track Track) bool {
	max_distance := (car.battery / car.batteryDrain) * car.speed
	if max_distance < track.distance {
		return false
	} 
		return true
//panic("Please implement the CanFinish function")
}

