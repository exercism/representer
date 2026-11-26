import ballerina/http;

# The exchange rate API base URL
final http:Client exchangeRateClient = check new ("http://localhost:8080");

final var exchangeRateApi = object {
    public function getRates(string baseCurrency) returns CurrencyRates|error {
        return exchangeRateClient->get(string `/rates/${baseCurrency}`);
    }
};

# Convert provided salary to local currency.
#
# + salary - Salary in source currency
# + sourceCurrency - Source currency
# + localCurrency - Employee's local currency
# + return - Salary in local currency or error
public function convertSalary(decimal salary, string sourceCurrency, string localCurrency) returns decimal|error {
    CurrencyRates exchangeRate = check exchangeRateApi.getRates(sourceCurrency);
    decimal? convertionRate = exchangeRate.rates[localCurrency];
    return convertionRate is () ? 0.0 : salary * convertionRate;
}

type CurrencyRates record {
    string base;
    map<decimal> rates;
};
