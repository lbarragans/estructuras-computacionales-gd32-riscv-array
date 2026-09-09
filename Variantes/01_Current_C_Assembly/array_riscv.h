#ifndef ARRAY_RISCV_H
#define ARRAY_RISCV_H

#include <stdint.h>

int32_t riscv_array_sum(const int32_t *values, uint32_t length);
int32_t riscv_array_max(const int32_t *values, uint32_t length);

#endif
