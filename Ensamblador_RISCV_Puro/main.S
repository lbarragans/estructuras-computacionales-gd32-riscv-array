.section .text
    .align 2

    /*
     * Ejercicio 02
     * Procesamiento de arreglos en Ensamblador RISC-V puro.
     *
     * No existe codigo C de aplicacion en este apartado.
     */

    .equ RCU_AHB1EN,         0x40023830
    .equ GPIOC_CTL,          0x40020800
    .equ GPIOC_OMODE,        0x40020804
    .equ GPIOC_OSPD,         0x40020808
    .equ GPIOC_PUD,          0x4002080C
    .equ GPIOC_BOP,          0x40020818
    .equ GPIOC_BC,           0x40020828
    .equ GPIOC_TG,           0x4002082C

    .equ GPIOC_CLOCK_BIT,    0x00000004
    .equ PC13_BIT,           0x00002000
    .equ PC13_FIELD_MASK,    0x0C000000
    .equ PC13_OUTPUT_MODE,   0x04000000
    .equ PC13_SPEED_10MHZ,   0x04000000

    .equ ARRAY_LENGTH,       6
    .equ EXPECTED_SUM,       8
    .equ EXPECTED_MAX,       5

    .global main
    .type main, @function

main:
    /* --------------------------------------------------------- */
    /* 1. GPIOC / PC13.                                         */
    /* --------------------------------------------------------- */
    li      t0, RCU_AHB1EN
    lw      t1, 0(t0)
    ori     t1, t1, GPIOC_CLOCK_BIT
    sw      t1, 0(t0)
    fence   iorw, iorw

    li      t0, GPIOC_CTL
    lw      t1, 0(t0)
    li      t2, PC13_FIELD_MASK
    not     t2, t2
    and     t1, t1, t2
    li      t2, PC13_OUTPUT_MODE
    or      t1, t1, t2
    sw      t1, 0(t0)

    li      t0, GPIOC_OMODE
    lw      t1, 0(t0)
    li      t2, PC13_BIT
    not     t2, t2
    and     t1, t1, t2
    sw      t1, 0(t0)

    li      t0, GPIOC_OSPD
    lw      t1, 0(t0)
    li      t2, PC13_FIELD_MASK
    not     t2, t2
    and     t1, t1, t2
    li      t2, PC13_SPEED_10MHZ
    or      t1, t1, t2
    sw      t1, 0(t0)

    li      t0, GPIOC_PUD
    lw      t1, 0(t0)
    li      t2, PC13_FIELD_MASK
    not     t2, t2
    and     t1, t1, t2
    sw      t1, 0(t0)

    /* LED activo en bajo: iniciar apagado. */
    li      t0, GPIOC_BOP
    li      t1, PC13_BIT
    sw      t1, 0(t0)

    /* --------------------------------------------------------- */
    /* 2. Procesar el arreglo.                                  */
    /* --------------------------------------------------------- */
    la      s0, test_values
    li      s1, ARRAY_LENGTH
    li      s2, 0
    lw      s3, 0(s0)

.Larray_loop:
    beqz    s1, .Larray_done

    lw      t0, 0(s0)
    add     s2, s2, t0

    /* Comparacion signed: conservar el mayor. */
    bge     s3, t0, .Lkeep_max
    mv      s3, t0

.Lkeep_max:
    addi    s0, s0, 4
    addi    s1, s1, -1
    j       .Larray_loop

.Larray_done:
    la      t0, g_sum_ensamblador
    sw      s2, 0(t0)

    la      t0, g_max_ensamblador
    sw      s3, 0(t0)

    /* --------------------------------------------------------- */
    /* 3. Comprobar resultados.                                 */
    /* --------------------------------------------------------- */
    li      t1, EXPECTED_SUM
    bne     s2, t1, .Lresults_error

    li      t1, EXPECTED_MAX
    bne     s3, t1, .Lresults_error

    la      t0, g_resultados_ok
    li      t1, 1
    sw      t1, 0(t0)

    j       .Lsuccess_sequence

.Lresults_error:
    la      t0, g_resultados_ok
    sw      zero, 0(t0)

.Lerror_loop:
    li      t0, GPIOC_TG
    li      t1, PC13_BIT
    sw      t1, 0(t0)

    li      a0, 100
    call    delay_aprox_ms
    j       .Lerror_loop

    /* --------------------------------------------------------- */
    /* 4. Mostrar el maximo mediante pulsos.                    */
    /* --------------------------------------------------------- */
.Lsuccess_sequence:
    mv      s4, s3

.Lpulse_loop:
    beqz    s4, .Lsequence_pause

    /* LED ON: PC13 = 0. */
    li      t0, GPIOC_BC
    li      t1, PC13_BIT
    sw      t1, 0(t0)

    li      a0, 200
    call    delay_aprox_ms

    /* LED OFF: PC13 = 1. */
    li      t0, GPIOC_BOP
    li      t1, PC13_BIT
    sw      t1, 0(t0)

    li      a0, 200
    call    delay_aprox_ms

    addi    s4, s4, -1
    j       .Lpulse_loop

.Lsequence_pause:
    li      a0, 1500
    call    delay_aprox_ms
    j       .Lsuccess_sequence

    .size main, .-main


    /*
     * a0 = milisegundos aproximados.
     * Espera activa educativa, equivalente al concepto de la referencia.
     */
    .align 2
    .type delay_aprox_ms, @function

delay_aprox_ms:
    mv      t0, a0

.Ldelay_ms_loop:
    beqz    t0, .Ldelay_done
    li      t1, 1000

.Ldelay_us_loop:
    li      t2, 16

.Ldelay_inner:
    nop
    addi    t2, t2, -1
    bnez    t2, .Ldelay_inner

    addi    t1, t1, -1
    bnez    t1, .Ldelay_us_loop

    addi    t0, t0, -1
    j       .Ldelay_ms_loop

.Ldelay_done:
    ret

    .size delay_aprox_ms, .-delay_aprox_ms


    .section .rodata
    .align 2

test_values:
    .word   2, -1, 5, 3, -2, 1


    .section .bss
    .align 2

    .global g_sum_ensamblador
    .global g_max_ensamblador
    .global g_resultados_ok

g_sum_ensamblador:
    .word 0

g_max_ensamblador:
    .word 0

g_resultados_ok:
    .word 0
