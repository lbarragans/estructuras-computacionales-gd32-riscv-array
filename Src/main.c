#include <stdint.h>

#include "gd32vw55x.h"
#include "array_riscv.h"

#define LED_GPIO_PORT          GPIOC
#define LED_GPIO_PIN           GPIO_PIN_13
#define LED_GPIO_CLOCK         RCU_GPIOC

#define PULSE_ON_MS            200U
#define PULSE_OFF_MS           200U
#define SEQUENCE_PAUSE_MS      1500U
#define ERROR_INTERVAL_MS      100U

/* Sum = 8, maximum = 5. */
static const int32_t test_values[] = {2, -1, 5, 3, -2, 1};

/* Global volatile variables remain visible in the debugger. */
volatile int32_t g_sum_c = 0;
volatile int32_t g_sum_asm = 0;
volatile int32_t g_max_c = 0;
volatile int32_t g_max_asm = 0;
volatile uint32_t g_results_match = 0U;

static void busy_wait_delay_us(uint32_t microseconds)
{
    volatile uint32_t cycles;

    while (microseconds-- > 0U) {
        cycles = 16U;
        while (cycles-- > 0U) {
            __asm volatile ("nop");
        }
    }
}

static void busy_wait_delay_ms(uint32_t milliseconds)
{
    while (milliseconds-- > 0U) {
        busy_wait_delay_us(1000U);
    }
}

static void led_init(void)
{
    rcu_periph_clock_enable(LED_GPIO_CLOCK);
    gpio_mode_set(LED_GPIO_PORT, GPIO_MODE_OUTPUT,
                  GPIO_PUPD_NONE, LED_GPIO_PIN);
    gpio_output_options_set(LED_GPIO_PORT, GPIO_OTYPE_PP,
                            GPIO_OSPEED_10MHZ, LED_GPIO_PIN);
    gpio_bit_set(LED_GPIO_PORT, LED_GPIO_PIN);
}

static void led_on(void)
{
    gpio_bit_reset(LED_GPIO_PORT, LED_GPIO_PIN);
}

static void led_off(void)
{
    gpio_bit_set(LED_GPIO_PORT, LED_GPIO_PIN);
}

static int32_t array_sum_c(const int32_t *values, uint32_t length)
{
    int32_t sum = 0;
    for (uint32_t index = 0U; index < length; ++index) {
        sum += values[index];
    }
    return sum;
}

static int32_t array_max_c(const int32_t *values, uint32_t length)
{
    if (length == 0U) {
        return 0;
    }

    int32_t maximum = values[0];
    for (uint32_t index = 1U; index < length; ++index) {
        if (values[index] > maximum) {
            maximum = values[index];
        }
    }
    return maximum;
}

static void led_show_value(uint32_t value)
{
    for (uint32_t pulse = 0U; pulse < value; ++pulse) {
        led_on();
        busy_wait_delay_ms(PULSE_ON_MS);
        led_off();
        busy_wait_delay_ms(PULSE_OFF_MS);
    }
    busy_wait_delay_ms(SEQUENCE_PAUSE_MS);
}

int main(void)
{
    const uint32_t length = sizeof(test_values) / sizeof(test_values[0]);

    led_init();
    g_sum_c = array_sum_c(test_values, length);
    g_sum_asm = riscv_array_sum(test_values, length);
    g_max_c = array_max_c(test_values, length);
    g_max_asm = riscv_array_max(test_values, length);
    g_results_match = (g_sum_c == g_sum_asm) && (g_max_c == g_max_asm);

    while (1) {
        if (g_results_match != 0U) {
            led_show_value((uint32_t)g_max_asm);
        } else {
            gpio_bit_toggle(LED_GPIO_PORT, LED_GPIO_PIN);
            busy_wait_delay_ms(ERROR_INTERVAL_MS);
        }
    }
}
