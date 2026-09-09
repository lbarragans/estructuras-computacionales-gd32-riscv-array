#ifndef ARRAY_STATS_H
#define ARRAY_STATS_H

#include <stdint.h>

typedef struct {
    int32_t sum;
    int32_t minimum;
    int32_t maximum;
    uint32_t positive_count;
} array_stats_t;

uint32_t riscv_array_stats(
    const int32_t *values,
    uint32_t length,
    array_stats_t *out
);

#endif
