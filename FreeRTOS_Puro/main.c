#include <stdint.h>

#include "app_cfg.h"
#include "gd32vw55x_platform.h"
#include "wrapper_os.h"

#include "gd32vw55x.h"
#include "FreeRTOS.h"
#include "queue.h"
#include "task.h"

#define LED_GPIO_PORT       GPIOC
#define LED_GPIO_PIN        GPIO_PIN_13
#define LED_GPIO_CLOCK      RCU_GPIOC

#define PULSE_ON_MS         200U
#define PULSE_OFF_MS        200U
#define SEQUENCE_PAUSE_MS   1500U
#define ERROR_INTERVAL_MS   100U
#define PRODUCER_PERIOD_MS  5000U

typedef struct {
    const int32_t *values;
    uint32_t length;
} array_job_t;

typedef struct {
    int32_t sum;
    int32_t maximum;
    uint32_t valid;
} array_result_t;

static const int32_t test_values[] = {
    2, -1, 5, 3, -2, 1
};

static QueueHandle_t job_queue;
static QueueHandle_t result_queue;

volatile int32_t g_freertos_sum = 0;
volatile int32_t g_freertos_max = 0;
volatile uint32_t g_freertos_ok = 0U;

static void led_init(void)
{
    rcu_periph_clock_enable(LED_GPIO_CLOCK);

    gpio_mode_set(
        LED_GPIO_PORT,
        GPIO_MODE_OUTPUT,
        GPIO_PUPD_NONE,
        LED_GPIO_PIN
    );

    gpio_output_options_set(
        LED_GPIO_PORT,
        GPIO_OTYPE_PP,
        GPIO_OSPEED_10MHZ,
        LED_GPIO_PIN
    );

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

static int32_t array_sum(const int32_t *values, uint32_t length)
{
    int32_t sum = 0;

    for (uint32_t i = 0U; i < length; ++i) {
        sum += values[i];
    }

    return sum;
}

static int32_t array_max(const int32_t *values, uint32_t length)
{
    if (length == 0U) {
        return 0;
    }

    int32_t maximum = values[0];

    for (uint32_t i = 1U; i < length; ++i) {
        if (values[i] > maximum) {
            maximum = values[i];
        }
    }

    return maximum;
}

static void producer_task(void *argument)
{
    (void)argument;

    const array_job_t job = {
        test_values,
        sizeof(test_values) / sizeof(test_values[0])
    };

    for (;;) {
        (void)xQueueSend(
            job_queue,
            &job,
            portMAX_DELAY
        );

        vTaskDelay(pdMS_TO_TICKS(PRODUCER_PERIOD_MS));
    }
}

static void processor_task(void *argument)
{
    (void)argument;

    array_job_t job;

    for (;;) {
        if (xQueueReceive(
                job_queue,
                &job,
                portMAX_DELAY
            ) == pdPASS) {

            array_result_t result;

            result.sum = array_sum(
                job.values,
                job.length
            );

            result.maximum = array_max(
                job.values,
                job.length
            );

            result.valid =
                (result.sum == 8) &&
                (result.maximum == 5);

            (void)xQueueSend(
                result_queue,
                &result,
                portMAX_DELAY
            );
        }
    }
}

static void indicator_task(void *argument)
{
    (void)argument;

    array_result_t result;

    for (;;) {
        if (xQueueReceive(
                result_queue,
                &result,
                portMAX_DELAY
            ) != pdPASS) {
            continue;
        }

        g_freertos_sum = result.sum;
        g_freertos_max = result.maximum;
        g_freertos_ok = result.valid;

        if (result.valid != 0U) {
            for (int32_t pulse = 0;
                 pulse < result.maximum;
                 ++pulse) {

                led_on();
                vTaskDelay(
                    pdMS_TO_TICKS(PULSE_ON_MS)
                );

                led_off();
                vTaskDelay(
                    pdMS_TO_TICKS(PULSE_OFF_MS)
                );
            }

            vTaskDelay(
                pdMS_TO_TICKS(SEQUENCE_PAUSE_MS)
            );
        } else {
            for (uint32_t pulse = 0U;
                 pulse < 10U;
                 ++pulse) {

                gpio_bit_toggle(
                    LED_GPIO_PORT,
                    LED_GPIO_PIN
                );

                vTaskDelay(
                    pdMS_TO_TICKS(ERROR_INTERVAL_MS)
                );
            }

            led_off();
        }
    }
}

int main(void)
{
    sys_os_init();
    platform_init();
    led_init();

    job_queue = xQueueCreate(
        2U,
        sizeof(array_job_t)
    );

    result_queue = xQueueCreate(
        2U,
        sizeof(array_result_t)
    );

    if ((job_queue == NULL) ||
        (result_queue == NULL)) {
        for (;;) {
        }
    }

    BaseType_t producer_ok = xTaskCreate(
        producer_task,
        "Producer",
        configMINIMAL_STACK_SIZE,
        NULL,
        tskIDLE_PRIORITY + 1U,
        NULL
    );

    BaseType_t processor_ok = xTaskCreate(
        processor_task,
        "Processor",
        configMINIMAL_STACK_SIZE,
        NULL,
        tskIDLE_PRIORITY + 2U,
        NULL
    );

    BaseType_t indicator_ok = xTaskCreate(
        indicator_task,
        "Indicator",
        configMINIMAL_STACK_SIZE,
        NULL,
        tskIDLE_PRIORITY + 1U,
        NULL
    );

    if ((producer_ok != pdPASS) ||
        (processor_ok != pdPASS) ||
        (indicator_ok != pdPASS)) {
        for (;;) {
        }
    }

    sys_os_start();

    for (;;) {
    }
}
