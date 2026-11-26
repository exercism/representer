import ballerina/regex;

# Returns Bob's response to someone talking to him.
#
# + input - whatever is said to Bob
# + return - Bob's response
public function hey(string input) returns string {
    string remark = input.trim();
    boolean question = remark.endsWith("?");
    boolean yelling = remark == remark.toUpperAscii() && regex:matches(remark, ".*?[a-zA-Z]+.*?");

    if remark == "" {
        return "Fine. Be that way!";
    }
    if question && yelling {
        return "Calm down, I know what I'm doing!";
    }
    if yelling {
        return "Whoa, chill out!";
    }
    if question {
        return "Sure.";
    }
    return "Whatever.";
}
