.section .text
    .align 2

    .global riscv_array_sum
    .type riscv_array_sum, @function

riscv_array_sum:
    mv      t0, a0
    mv      t1, a1
    li      a0, 0
    beqz    t1, .Lsum_done

.Lsum_loop:
    lw      t2, 0(t0)
    add     a0, a0, t2
    addi    t0, t0, 4
    addi    t1, t1, -1
    bnez    t1, .Lsum_loop

.Lsum_done:
    ret

    .size riscv_array_sum, .-riscv_array_sum

    .global riscv_array_max
    .type riscv_array_max, @function

riscv_array_max:
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

    .size riscv_array_max, .-riscv_array_max
