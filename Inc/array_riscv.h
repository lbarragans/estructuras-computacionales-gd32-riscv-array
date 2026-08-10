#ifndef ARRAY_RISCV_H
#define ARRAY_RISCV_H

#include <stdint.h>

/*
 * RISC-V ABI:
 *   a0: pointer to the first element, then the return value
 *   a1: number of elements
 */
int32_t riscv_array_sum(const int32_t *values, uint32_t length);
int32_t riscv_array_max(const int32_t *values, uint32_t length);

#endif
