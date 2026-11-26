import java.util.EmptyStackException;
import java.util.Stack;

class BracketChecker{

    String input;

    BracketChecker(String input) {
        this.input = input;
    }

    boolean areBracketsMatchedAndNestedCorrectly() {
        Stack<Character> stack = new Stack<Character>();
        for (int i = 0; i < input.length(); i++) {
            char cursor = input.charAt(i);
            if(cursor == '(' || cursor == '[' || cursor =='{'){
                stack.push(cursor);
                continue;
            }

            char check;
            try {
                switch (cursor) {
                    case ')':
                        check = stack.pop();
                        if (check == '{' || check == '[')
                            return false;
                        break;

                    case '}':
                        check = stack.pop();
                        if (check == '(' || check == '[')
                            return false;
                        break;

                    case ']':
                        check = stack.pop();
                        if (check == '(' || check == '{')
                            return false;
                        break;
                }
            } catch(EmptyStackException e){
                return false;
            }
        }
        return (stack.isEmpty());
    }
}