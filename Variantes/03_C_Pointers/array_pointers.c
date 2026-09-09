#include <stdint.h>

int32_t array_sum_pointer(const int32_t *values, uint32_t length)
{
    const int32_t *ptr = values;
    const int32_t *end = values + length;
    int32_t sum = 0;

    while (ptr < end) {
        sum += *ptr;
        ++ptr;
    }

    return sum;
}

int32_t array_max_pointer(const int32_t *values, uint32_t length)
{
    if (length == 0U) {
        return 0;
    }

    const int32_t *ptr = values + 1U;
    const int32_t *end = values + length;
    int32_t maximum = values[0];

    while (ptr < end) {
        if (*ptr > maximum) {
            maximum = *ptr;
        }
        ++ptr;
    }

    return maximum;
}
