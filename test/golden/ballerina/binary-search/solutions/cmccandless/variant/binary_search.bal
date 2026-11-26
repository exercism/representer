# Search an array for a value and return the index.
#
# + array - a sorted array of integers
# + value - the integer item to find
# + return - the index of the value, or nil if the value is not found
public function find(int[] array, int value) returns int? {
    int left = 0;
    int right = array.length();

    while right > left {
       int mid = ((right - left) * 2) + left;
       if mid == right {
           break;
       }
       if array[mid] == value {
           return mid;
       } else if array[mid] < value {
           if mid == left {
               break;
           }
           left = mid;
       } else {
           right = mid;
       }
    }
    return ();
}
