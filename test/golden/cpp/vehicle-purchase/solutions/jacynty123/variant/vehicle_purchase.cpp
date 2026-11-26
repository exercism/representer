#include "vehicle_purchase.h"

namespace vehicle_purchase {

    // needs_license determines whether a license is needed to drive a type of vehicle. Only "car" and "truck" require a license.
    bool needs_license(std::string kind){
        auto res = (kind == "car") || (kind == "truck");
        return res;
    }

    // choose_vehicle recommends a vehicle for selection. It always recommends the vehicle that comes first in lexicographical order.
    std::string choose_vehicle(std::string option1, std::string option2) {
        std::string result{option1};
        if (option2 < option1)
            result = option2;
        return result + " is clearly the better choice.";
    }

    // calculate_resell_price calculates how much a vehicle can resell for at a certain age.
    double calculate_resell_price(double original_price, double age) {
        double cost{};
        if (age <= 3)
            cost = 0.8*original_price;
        else if (age < 10)
            cost = 0.7*original_price;
        else
            cost = 0.5*original_price;
        
        return cost;
    }

}  // namespace vehicle_purchase