public function find(int[] array, int value) returns int? {
    int first = 0;
    int last = array.length() - 1;

    while first <= last {
        int middle = (first + last) / 2;
        if array[middle] == value { return middle; }
        if array[middle] > value {
            last = middle - 1;
        } else {
            first = middle + 1;
        }
    }
}
