import ballerina/http;

// Client endpoint to communicate with Airline reservation service
final http:Client airlineReservationEP = check new ("http://localhost:9091/airline");

// Client endpoint to communicate with Hotel reservation service
final http:Client hotelReservationEP = check new ("http://localhost:9092/hotel");

// Client endpoint to communicate with Car rental service
final http:Client carRentalEP = check new ("http://localhost:9093/car");

// Travel agency service to arrange a complete tour for a user
service /travel on new http:Listener(9090) {

    // Define a resource method to arrange a tour, that accepts `POST` requests in the path `/arrangeTour`.
    // This resource should accept a value of the type `TourArrangement` that already defined below.
    resource function post arrangeTour(@http:Payload TourArrangement arrangement) returns http:StatusCodeResponse|error? {
        var { name, arrivalDate, departureDate, preference} = arrangement;
        var { airline, accomodation, car } = preference;


        ServiceResponse airlineResp = check airlineReservationEP->/reserve.post(<Reservation>{
            name,
            arrivalDate,
            departureDate,
            preference: airline
        });
        if airlineResp.status == FAILED {
            return <http:BadRequest>{
                body: {
                    message: "Failed to reserve airline! Provide a valid 'preference' for 'airline' and try again"
                }
            };
        }

        ServiceResponse hotelResp = check hotelReservationEP->/reserve.post(<Reservation>{
            name,
            arrivalDate,
            departureDate,
            preference: accomodation
        });
        if hotelResp.status == FAILED {
            return <http:BadRequest>{
                body: {
                    message: "Failed to reserve hotel! Provide a valid 'preference' for 'accommodation' and try again"
                }
            };
        }

        ServiceResponse carResp = check carRentalEP->/rent.post(<Reservation>{
            name,
            arrivalDate,
            departureDate,
            preference: car
        });
        if carResp.status == FAILED {
            return <http:BadRequest>{
                body: {
                    message: "Failed to rent car! Provide a valid 'preference' for 'car' and try again"
                }
            };
        }

        return <http:Created> {
               body: {message: "Congratulations! Your journey is ready!!"}
            };
    }
        
}

# The payload type received from the tour arrangement service.
#
# + name - Name of the tourist
# + arrivalDate - The arrival date of the tourist
# + departureDate - The departure date of the tourist
# + preference - The preferences for the airline, hotel, and the car rental
type TourArrangement record {|
    string name;
    string arrivalDate;
    string departureDate;
    Preference preference;
|};

# The different prefenrences for the tour.
#
# + airline - The preference for airline ticket. Can be `First`, `Bussiness`, `Economy`
# + accomodation - The prefenerece for the hotel reservarion. Can be `delux` or `superior`
# + car - The preference for the car rental. Can be `air conditioned`, or `normal`
type Preference record {|
    string airline;
    string accomodation;
    string car;
|};

// Define a record type to send requests to the reservation services.
type Reservation record {|
    string name;
    string arrivalDate;
    string departureDate;
    string preference;
|};

// The response type received from the reservation services
type ServiceResponse record {|
    Status status;
|};

// Possible statuses of the reservation service responses
enum Status {
    SUCCESS = "Success",
    FAILED = "Failed"
}
