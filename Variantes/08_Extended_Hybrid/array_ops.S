.section .text
    .align 2

    .global riscv_array_min
riscv_array_min:
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

    .global riscv_count_positive
riscv_count_positive:
    mv      t0, a0
    mv      t1, a1
    li      a0, 0
.Lcp_loop:
    beqz    t1, .Lcp_done
    lw      t2, 0(t0)
    bge     zero, t2, .Lcp_next
    addi    a0, a0, 1
.Lcp_next:
    addi    t0, t0, 4
    addi    t1, t1, -1
    j       .Lcp_loop
.Lcp_done:
    ret
