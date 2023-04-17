import java.io.*;

class Calc {
    int token; 
    int value; 
    int ch;
    private PushbackInputStream input;
    final int NUMBER = 256;

    Calc(PushbackInputStream is) {
        input = is;
    }

    int getToken() { /* tokens are characters */
        while (true) {
            try {
                ch = input.read();
                if (ch == ' ' || ch == '\t' || ch == '\r')
                    ;
                else if (Character.isDigit(ch)) {
                    value = number();
                    input.unread(ch);
                    return NUMBER;
                } else
                    return ch;
            } catch (IOException e) {
                System.err.println(e);
            }
        }
    }

    private int number() { /* number -> digit { digit } */
        int result = ch - '0';
        try {
            ch = input.read();
            while (Character.isDigit(ch)) {
                result = 10 * result + ch - '0';
                ch = input.read();
            }
        } catch (IOException e) {
            System.err.println(e);
        }
        return result;
    }

    void error() {
        System.out.printf("parse error : %c\n", ch);
        // System.exit(1);
    }

    void match(int c) {
        if (token == c)
            token = getToken();
        else
            error();
    }

    void command() { /* command -> expr '\n' */
        int result = expr();
        if (token == '\n') /* end the parse and print the result */
            System.out.println(result);
        else
            error();
    }

    int expr() {
        int result = term();
        while (token == '+' || token == '-') {
            char op = token;
            match(token);
            int termResult = term();
            if (op == '+') {
                result += termResult;
            } else {
                result -= termResult;
            }
        }
        return result;
    }

    int term() {
        int result = factor();
        while (token == '*' || token == '/') {
            char op = token;
            match(token);
            int factorResult = factor();
            if (op == '*') {
                result *= factorResult;
            } else {
                result /= factorResult;
            }
        }
        return result;
    }

    int factor() {
        int result = 0;
        if (token == '(') {
            match('(');
            result = expr();
            match(')');
        } else if (token == NUMBER) {
            result = value;
            match(NUMBER);
        } else if (token == '-') {
            match('-');
            result = -factor();
        } else {
            error();
        }
        return result;
    }

    void parse() {
        token = getToken(); // get the first token
        command(); // call the parsing command
    }

    public static void main(String args[]) {
        Calc calc = new Calc(new PushbackInputStream(System.in));
        while (true) {
            System.out.print(">> ");
            calc.parse();
        }
    }
}
