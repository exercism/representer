import ballerina/http;
import ballerina/io;
// Use the following endpoints to send HTTP GET request to get quotes

// This is an existing endpoint (which will be automatically spawned by the test framework)
final http:Client brainyQuoteClient = check new ("http://localhost:9095/brainyquote");

// This is a non-existing endpoint.
final http:Client legacyClient = check new ("http://localhost:6060/legacyquote");

type Response string|error;

public function main() returns error? {

    // Invoke the `brainyQuoteClient` using HTTP GET request on "/"
    // Invocation returns a 'union type' which can either be an 'string' type or an 'error' type.
    // Assign it to variable.
    Response defaultResponse = brainyQuoteClient -> get("/");
    if defaultResponse is error {
        io:println(defaultResponse.message());
        return defaultResponse;
    } else {
        io:println(defaultResponse);
    }

    Response legacyResponse = legacyClient -> get("/");
    if legacyResponse is error {
        io:println(legacyResponse.message());
        return legacyResponse;
    } else {
        io:println(legacyResponse);
    }

    return check legacyClient -> /;
}
