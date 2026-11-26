// INFO: Headers from the standard library should be inserted at the top via
#include <cmath>

double daily_rate(double hourly_rate) {
    return hourly_rate*8;
}

double apply_discount(double before_discount, double discount) {
    double discount_formatted = (100-discount) / 100;
    return before_discount*(discount_formatted);
}

int monthly_rate(double hourly_rate, double discount) {
    double monthly_base_cost = daily_rate(hourly_rate) * 22;
    return ceil(apply_discount(monthly_base_cost, discount));
}


int days_in_budget(int budget, double hourly_rate, double discount) {
    double rate = daily_rate(hourly_rate);
    double daily_rate_with_discount = apply_discount(rate,discount);
    return floor(budget / daily_rate_with_discount);
}
