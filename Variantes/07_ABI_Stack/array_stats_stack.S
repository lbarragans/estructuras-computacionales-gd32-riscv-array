.section .text
    .align 2

    .global riscv_array_stats
    .type riscv_array_stats, @function

/*
 * uint32_t riscv_array_stats(const int32_t *values,
 *                            uint32_t length,
 *                            array_stats_t *out);
 *
 * a0 = values
 * a1 = length
 * a2 = out
 *
 * out:
 *   +0  sum
 *   +4  minimum
 *   +8  maximum
 *   +12 positive_count
 */
riscv_array_stats:
    addi    sp, sp, -32
    sw      ra, 28(sp)
    sw      s0, 24(sp)
    sw      s1, 20(sp)
    sw      s2, 16(sp)
    sw      s3, 12(sp)
    sw      s4, 8(sp)

    mv      s0, a0          /* pointer */
    mv      s1, a1          /* length  */
    mv      s2, a2          /* out     */

    beqz    s1, .Lempty

    lw      s3, 0(s0)       /* minimum */
    mv      s4, s3          /* maximum */
    li      t0, 0           /* sum */
    li      t1, 0           /* positive count */

.Lloop:
    lw      t2, 0(s0)
    add     t0, t0, t2

    bge     t2, s3, .Lnot_min
    mv      s3, t2
.Lnot_min:

    bge     s4, t2, .Lnot_max
    mv      s4, t2
.Lnot_max:

    bge     zero, t2, .Lnot_positive
    addi    t1, t1, 1
.Lnot_positive:

    addi    s0, s0, 4
    addi    s1, s1, -1
    bnez    s1, .Lloop

    sw      t0, 0(s2)
    sw      s3, 4(s2)
    sw      s4, 8(s2)
    sw      t1, 12(s2)

    li      a0, 1
    j       .Lreturn

.Lempty:
    sw      zero, 0(s2)
    sw      zero, 4(s2)
    sw      zero, 8(s2)
    sw      zero, 12(s2)
    li      a0, 0

.Lreturn:
    lw      s4, 8(sp)
    lw      s3, 12(sp)
    lw      s2, 16(sp)
    lw      s1, 20(sp)
    lw      s0, 24(sp)
    lw      ra, 28(sp)
    addi    sp, sp, 32
    ret

    .size riscv_array_stats, .-riscv_array_stats
