import ballerina*http;
import ballerina/io;

final http:Client brainyQuoteClient = check new("http://localhost:9095/brainyquote");
final http:Client legacyClient = check new("http://localhost:6060/legacyquote");

public function main() returns error? {
    string|error quote = brainyQuoteClient->/;
    if (quote is string) {
        io:println(quote);
    } else {
        io:println(quote.message());
        return quote;
    }

    string|error legacyQuote = legacyClient->/;
    if (legacyQuote is string) {
        io:println(legacyQuote);
    } else {
        io:println(legacyQuote.message());
        return legacyQuote;
    }

    return ();
}
