module SpaceAge

public export
data Planet = Mercury | Venus | Earth | Mars | Jupiter | Saturn | Uranus | Neptune

earthAge : Integer -> Double
earthAge seconds = cast seconds / 31_557_600

export
age : Planet -> Integer -> Double
age Mercury seconds = earthAge seconds /   0.2408467
age Venus   seconds = earthAge seconds /   0.61519726
age Earth   seconds = earthAge seconds
age Mars    seconds = earthAge seconds /   1.8808158
age Jupiter seconds = earthAge seconds /  11.862615
age Saturn  seconds = earthAge seconds /  29.447498
age Uranus  seconds = earthAge seconds /  84.016846
age Neptune seconds = earthAge seconds / 164.79132
