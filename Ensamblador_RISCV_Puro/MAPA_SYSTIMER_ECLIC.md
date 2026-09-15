# Mapa usado por la implementacion

## GPIOC

```text
RCU_AHB1EN   = 0x40023830

GPIOC_CTL    = 0x40020800
GPIOC_OMODE  = 0x40020804
GPIOC_OSPD   = 0x40020808
GPIOC_PUD    = 0x4002080C
GPIOC_BC     = 0x40020828
GPIOC_TG     = 0x4002082C
```

PC13:

```text
bit               = 0x00002000
campo [27:26]     = 0x0C000000
modo salida       = 0x04000000
velocidad 10 MHz  = 0x04000000
```

## SysTimer

```text
SYSTIMER_BASE      = 0xD1000000
MTIMER low         = +0x000
MTIMER high        = +0x004
MTIMERCMP low      = +0x008
MTIMERCMP high     = +0x00C
MTIMECTL           = +0xFF8
```

`CMPCLREN` es el bit 1:

```text
MTIMECTL = 0x00000002
```

## ECLIC

```text
ECLIC_BASE         = 0xD2000000
IRQ SysTimer       = 7
CTRL base          = ECLIC_BASE + 0x1000 + 7*4
                   = 0xD200101C

INTIP              = 0xD200101C
INTIE              = 0xD200101D
INTATTR            = 0xD200101E
INTCTRL            = 0xD200101F
```

Trigger positivo:

```text
INTATTR.TRIG = 01b
valor        = 0x02
```

## Periodo de 1 ms

Para la configuracion actual de 160 MHz:

```text
compare = 160000000 / 4000 = 40000
```

Si en el futuro se cambia el reloj del sistema, esta constante debe actualizarse.
