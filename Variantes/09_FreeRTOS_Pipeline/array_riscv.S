.section .text
    .align 2

    .global riscv_array_sum
riscv_array_sum:
    mv      t0, a0
    mv      t1, a1
    li      a0, 0
.Lsum:
    beqz    t1, .Lsum_done
    lw      t2, 0(t0)
    add     a0, a0, t2
    addi    t0, t0, 4
    addi    t1, t1, -1
    j       .Lsum
.Lsum_done:
    ret

    .global riscv_array_max
riscv_array_max:
    beqz    a1, .Lmax_empty
    lw      t0, 0(a0)
    addi    a0, a0, 4
    addi    a1, a1, -1
.Lmax:
    beqz    a1, .Lmax_done
    lw      t1, 0(a0)
    bge     t0, t1, .Lmax_next
    mv      t0, t1
.Lmax_next:
    addi    a0, a0, 4
    addi    a1, a1, -1
    j       .Lmax
.Lmax_done:
    mv      a0, t0
    ret
.Lmax_empty:
    li      a0, 0
    ret
