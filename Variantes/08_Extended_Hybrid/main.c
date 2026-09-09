#include <stdint.h>

extern int32_t riscv_array_min(const int32_t *values, uint32_t length);
extern uint32_t riscv_count_positive(const int32_t *values, uint32_t length);

static const int32_t values[] = {2, -1, 5, 3, -2, 1};

static int32_t sum_c(const int32_t *v, uint32_t n)
{
    int32_t sum = 0;

    for (uint32_t i = 0U; i < n; ++i) {
        sum += v[i];
    }

    return sum;
}

int main(void)
{
    const uint32_t n = sizeof(values) / sizeof(values[0]);

    volatile int32_t sum = sum_c(values, n);
    volatile int32_t minimum = riscv_array_min(values, n);
    volatile uint32_t positives = riscv_count_positive(values, n);

    /*
     * sum       = 8
     * minimum   = -2
     * positives = 4
     */
    (void)sum;
    (void)minimum;
    (void)positives;

    for (;;) {
    }
}
