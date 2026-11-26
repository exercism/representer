import java.util.*;

class Flattener {

    <T> List<T> flatten(List<T> list) {
        List<T> flat = new ArrayList<>();
         for (Object element : list) {
            if (element instanceof List) {
                flat.addAll(flatten((List<T>) element));
            } else if (element == null) {
                flat.add((T) element);
            }
        }
        
        return flat;
    }
}