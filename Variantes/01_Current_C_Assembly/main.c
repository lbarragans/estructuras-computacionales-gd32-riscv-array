#include <stdint.h>
#include "array_riscv.h"

static const int32_t values[] = {2, -1, 5, 3, -2, 1};

static int32_t array_sum_c(const int32_t *data, uint32_t length)
{
    int32_t sum = 0;

    for (uint32_t i = 0U; i < length; ++i) {
        sum += data[i];
    }

    return sum;
}

static int32_t array_max_c(const int32_t *data, uint32_t length)
{
    if (length == 0U) {
        return 0;
    }

    int32_t maximum = data[0];

    for (uint32_t i = 1U; i < length; ++i) {
        if (data[i] > maximum) {
            maximum = data[i];
        }
    }

    return maximum;
}

/* Harness minimo de comparacion, sin la capa de LED. */
int main(void)
{
    const uint32_t length = sizeof(values) / sizeof(values[0]);
    volatile int32_t sum_c = array_sum_c(values, length);
    volatile int32_t sum_asm = riscv_array_sum(values, length);
    volatile int32_t max_c = array_max_c(values, length);
    volatile int32_t max_asm = riscv_array_max(values, length);
    volatile uint32_t match = (sum_c == sum_asm) && (max_c == max_asm);

    (void)match;

    for (;;) {
    }
}
