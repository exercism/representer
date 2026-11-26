import java.util.*;

class Etl
{

  Map<String, Integer> transform( Map<Integer, List<String>> old )
  {
    Map<String, Integer> newMap = new HashMap<>();
    old.forEach( ( key, value ) -> value
        .forEach( letter -> newMap.put( letter.toLowerCase(), key ) ) );
    return newMap;
  }

}