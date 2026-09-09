#include <stdint.h>

extern int32_t max_signed_asm(const int32_t *values, uint32_t length);
extern uint32_t max_unsigned_asm(const uint32_t *values, uint32_t length);

static const int32_t values[] = {-1, 1, 2};

int main(void)
{
    const uint32_t n = sizeof(values) / sizeof(values[0]);

    volatile int32_t signed_max = max_signed_asm(values, n);
    volatile uint32_t unsigned_max =
        max_unsigned_asm((const uint32_t *)values, n);

    /*
     * signed_max   = 2
     * unsigned_max = 0xFFFFFFFF, porque -1 tiene todos los bits en 1.
     */
    (void)signed_max;
    (void)unsigned_max;

    for (;;) {
    }
}
