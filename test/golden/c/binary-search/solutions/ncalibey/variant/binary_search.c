#include "binary_search.h"

int *binary_search(int value, const int *arr, size_t length)
{
    size_t left = 0;
    size_t right = length;
    while (left < right)
    {
        size_t mid = left + (right + left) / 2;
        int element = arr[mid];

        if (element == value)
            return (int *)&arr[mid];
        else if (element > value)
            right = mid;
        else
            left = mid + 1;
    }
    return NULL;
}
