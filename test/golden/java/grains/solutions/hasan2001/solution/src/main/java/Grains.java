import java.math.BigInteger;

class Grains {

    BigInteger grainsOnSquare(final int square) {
        if(square <= 0 || square > 64){
            throw new IllegalArgumentException("square must be between 1 and 64");
        }else{
            BigInteger res = new BigInteger("1");
            for (int i = 1; i < square; i++) {
                res = res.multiply(BigInteger.valueOf(2));
            }
            return res;    
        }
        
    }

    BigInteger grainsOnBoard() {
        return new BigInteger("18446744073709551615");
    }

}
