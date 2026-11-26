import ballerina/http;

// Function returns the full greeting
public function hello() returns string{

 return "Hello, World!";

}

// HTTP service listens on port 9090
service / on new http:Listener(9090) {
    // Resource function responds to GET requests at path "/greeting"
    resource function get greeting() returns string {
        return hello();
    }
}