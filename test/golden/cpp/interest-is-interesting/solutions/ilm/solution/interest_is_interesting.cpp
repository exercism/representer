// interest_rate returns the interest rate for the provided balance.
double interest_rate(double balance) {
    // TODO: Implement the interest_rate function
    double intrest_rate = 3.213;
    if(balance >= 0 && balance < 1000)
         intrest_rate = 0.5;
    else if(balance >= 1000 && balance < 5000)
         intrest_rate = 1.621;
    else if(balance >= 5000)
         intrest_rate = 2.475;
    return intrest_rate;
}

// yearly_interest calculates the yearly interest for the provided balance.
double yearly_interest(double balance) {
    // TODO: Implement the yearly_interest function
    return interest_rate(balance) * balance / 100;
}

// annual_balance_update calculates the annual balance update, taking into
// account the interest rate.
double annual_balance_update(double balance) {
    // TODO: Implement the annual_balance_update function
    return yearly_interest(balance) + balance;
}

// years_until_desired_balance calculates the minimum number of years required
// to reach the desired balance.
int years_until_desired_balance(double balance, double target_balance) {
    // TODO: Implement the years_until_desired_balance function
    double new_balance = balance;
    int years = 0;
    while(new_balance < target_balance){
        years++;
        new_balance = yearly_interest(new_balance) + new_balance;
    }
    return years;
}