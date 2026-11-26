# Search an array for a value and return the index.
#
# + array - a sorted array of integers
# + value - the integer item to find
# + return - the index of the value, or nil if the value is not found
public function find(int[] array, int value) returns int? {
    int l = 0;
    int u = array.length();

    // Check the  edge cases
    if u == 0 || value < array[l] || value > array[u-1] {
        return ();
    }

    int up = u - 1; // Reset the length to the upper index
    while l <= up {
        int k = (l + up) / 2; // Get the middle value
        if value == array[k] {
            return k;
        } else if value > array[k] {
            l = k + 1;
        } else {
            up = k - 1;
        }
    }

    return ();
}
