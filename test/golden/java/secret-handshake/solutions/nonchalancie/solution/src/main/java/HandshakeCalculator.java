import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

class HandshakeCalculator {

    List<Signal> calculateHandshake(int number) {
        List<Signal> res = new ArrayList<>();
        for(Signal s : Signal.values()){
            if(number % 2 == 1){
                res.add(s);
            }
            number /= 2;
        }
        if(number % 2 == 1){
            Collections.reverse(res);
        }
        return res;
    }

}
