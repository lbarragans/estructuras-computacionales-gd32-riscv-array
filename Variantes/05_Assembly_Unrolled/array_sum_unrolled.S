.section .text
    .align 2

    /* int32_t array_sum_unrolled2(const int32_t *p, uint32_t n) */
    .global array_sum_unrolled2
    .type array_sum_unrolled2, @function

array_sum_unrolled2:
    mv      t0, a0
    mv      t1, a1
    li      a0, 0

    /* Procesar pares mientras n >= 2. */
.Lpair_test:
    li      t4, 2
    bltu    t1, t4, .Ltail

    lw      t2, 0(t0)
    lw      t3, 4(t0)
    add     a0, a0, t2
    add     a0, a0, t3

    addi    t0, t0, 8
    addi    t1, t1, -2
    j       .Lpair_test

.Ltail:
    beqz    t1, .Ldone
    lw      t2, 0(t0)
    add     a0, a0, t2

.Ldone:
    ret

    .size array_sum_unrolled2, .-array_sum_unrolled2
