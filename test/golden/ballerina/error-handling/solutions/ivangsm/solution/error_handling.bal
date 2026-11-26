import ballerina/http;
import ballerina/io;

final http:Client brainyQuoteClient = check new("http://localhost:9095/brainyquote");
final http:Client legacyClient = check new("http://localhost:6060/legacyquote");

public function main() returns error? {
    string|error resultBrainy = brainyQuoteClient->/;

    if resultBrainy is error {
      io:println(resultBrainy.message());
    } else {
      io:println(resultBrainy);
    }

        
    string|error resultLegacy = legacyClient->/;
    if resultLegacy is error {
      io:println(resultLegacy.message());
    } else {
      io:println(resultLegacy);
    }


    string result = check legacyClient->/;
    io:println(result);
}