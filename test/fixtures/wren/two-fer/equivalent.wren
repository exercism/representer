// Two-fer with other names and layout.
class Greeter {
    static greet() { return "One for you, one for me." }

    /* with a name */
    static greet(person) {
        return "One for %(person), one for me."
    }
}
