import ballerina/http;

service / on new http:Listener(9090) {

    resource function post greeting() returns string {
        return "Hello, Ballerina!";
    }
}
