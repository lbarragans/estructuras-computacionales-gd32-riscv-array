.section .text
    .align 2

    /* int32_t max_signed_asm(const int32_t *p, uint32_t n) */
    .global max_signed_asm
max_signed_asm:
    beqz    a1, .Ls_empty
    lw      t0, 0(a0)
    addi    a0, a0, 4
    addi    a1, a1, -1
.Ls_loop:
    beqz    a1, .Ls_done
    lw      t1, 0(a0)
    bge     t0, t1, .Ls_next
    mv      t0, t1
.Ls_next:
    addi    a0, a0, 4
    addi    a1, a1, -1
    j       .Ls_loop
.Ls_done:
    mv      a0, t0
    ret
.Ls_empty:
    li      a0, 0
    ret

    /* uint32_t max_unsigned_asm(const uint32_t *p, uint32_t n) */
    .global max_unsigned_asm
max_unsigned_asm:
    beqz    a1, .Lu_empty
    lw      t0, 0(a0)
    addi    a0, a0, 4
    addi    a1, a1, -1
.Lu_loop:
    beqz    a1, .Lu_done
    lw      t1, 0(a0)
    bgeu    t0, t1, .Lu_next
    mv      t0, t1
.Lu_next:
    addi    a0, a0, 4
    addi    a1, a1, -1
    j       .Lu_loop
.Lu_done:
    mv      a0, t0
    ret
.Lu_empty:
    li      a0, 0
    ret
