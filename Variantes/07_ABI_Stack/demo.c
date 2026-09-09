#include <stdint.h>
#include "array_stats.h"

static const int32_t values[] = {2, -1, 5, 3, -2, 1};

int main(void)
{
    array_stats_t stats = {0};
    const uint32_t n = sizeof(values) / sizeof(values[0]);

    volatile uint32_t ok = riscv_array_stats(values, n, &stats);

    /*
     * Esperado:
     * ok             = 1
     * stats.sum      = 8
     * stats.minimum  = -2
     * stats.maximum  = 5
     * positive_count = 4
     */
    (void)ok;

    for (;;) {
    }
}
