import ballerina/http;
import ballerina/io;

final http:Client brainyQuoteClient = check new ("http://localhost:9095/brainyquote");

public function main() {

    // Invoke the HTTP client and try to retrive a quote. This result should be a union type consisting `string` and `error`
    string|error a = brainyQuoteClient->/;

    // If the quote is received, print it to the console (using `io:println()`).
    if a is error {
        io:println(a.message());
    } else {
        io:println(a);
    }

    // If an `error` has occurred, print the error message to the console
}
