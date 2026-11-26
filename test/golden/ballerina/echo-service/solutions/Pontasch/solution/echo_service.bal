import ballerina/http;

service / on new http:Listener(8080) {

    // This resource should accept a GET request at the path `/echo` and have a query param `sound`
    resource function GET echo(string sound) returns string {
        return sound;
    }

    // This resource should accept a GET request at the path `/echo/definition`
    resource function GET echo/definition() returns string|error? {
         return "A sound or series of sounds caused by the reflection of sound waves from a surface back to the listener.";
    }
}
