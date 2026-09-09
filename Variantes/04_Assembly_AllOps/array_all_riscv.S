.section .text
    .align 2

    /* int32_t array_sum_asm(const int32_t *p, uint32_t n) */
    .global array_sum_asm
array_sum_asm:
    mv      t0, a0
    mv      t1, a1
    li      a0, 0
.Lsum_loop:
    beqz    t1, .Lsum_done
    lw      t2, 0(t0)
    add     a0, a0, t2
    addi    t0, t0, 4
    addi    t1, t1, -1
    j       .Lsum_loop
.Lsum_done:
    ret

    /* int32_t array_min_asm(const int32_t *p, uint32_t n) */
    .global array_min_asm
array_min_asm:
    beqz    a1, .Lmin_empty
    lw      t0, 0(a0)
    addi    a0, a0, 4
    addi    a1, a1, -1
.Lmin_loop:
    beqz    a1, .Lmin_done
    lw      t1, 0(a0)
    bge     t1, t0, .Lmin_next
    mv      t0, t1
.Lmin_next:
    addi    a0, a0, 4
    addi    a1, a1, -1
    j       .Lmin_loop
.Lmin_done:
    mv      a0, t0
    ret
.Lmin_empty:
    li      a0, 0
    ret

    /* int32_t array_max_asm(const int32_t *p, uint32_t n) */
    .global array_max_asm
array_max_asm:
    beqz    a1, .Lmax_empty
    lw      t0, 0(a0)
    addi    a0, a0, 4
    addi    a1, a1, -1
.Lmax_loop:
    beqz    a1, .Lmax_done
    lw      t1, 0(a0)
    bge     t0, t1, .Lmax_next
    mv      t0, t1
.Lmax_next:
    addi    a0, a0, 4
    addi    a1, a1, -1
    j       .Lmax_loop
.Lmax_done:
    mv      a0, t0
    ret
.Lmax_empty:
    li      a0, 0
    ret

    /* uint32_t array_count_positive_asm(const int32_t *p, uint32_t n) */
    .global array_count_positive_asm
array_count_positive_asm:
    mv      t0, a0
    mv      t1, a1
    li      a0, 0
.Lcount_loop:
    beqz    t1, .Lcount_done
    lw      t2, 0(t0)
    bge     zero, t2, .Lcount_next
    addi    a0, a0, 1
.Lcount_next:
    addi    t0, t0, 4
    addi    t1, t1, -1
    j       .Lcount_loop
.Lcount_done:
    ret
