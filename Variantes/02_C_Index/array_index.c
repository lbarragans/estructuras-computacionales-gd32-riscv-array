#include <stdint.h>

int32_t array_sum_index(const int32_t *values, uint32_t length)
{
    int32_t sum = 0;

    for (uint32_t index = 0U; index < length; ++index) {
        sum += values[index];
    }

    return sum;
}

int32_t array_max_index(const int32_t *values, uint32_t length)
{
    if (length == 0U) {
        return 0;
    }

    int32_t maximum = values[0];

    for (uint32_t index = 1U; index < length; ++index) {
        if (values[index] > maximum) {
            maximum = values[index];
        }
    }

    return maximum;
}
