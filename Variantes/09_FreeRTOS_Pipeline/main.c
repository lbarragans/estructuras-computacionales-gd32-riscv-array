#include <stdint.h>

#include "FreeRTOS.h"
#include "queue.h"
#include "task.h"

typedef struct {
    const int32_t *values;
    uint32_t length;
} array_job_t;

typedef struct {
    const int32_t *values;
    uint32_t length;
    int32_t sum_asm;
    int32_t max_asm;
} array_result_t;

extern int32_t riscv_array_sum(const int32_t *values, uint32_t length);
extern int32_t riscv_array_max(const int32_t *values, uint32_t length);

static const int32_t test_values[] = {2, -1, 5, 3, -2, 1};

static QueueHandle_t job_queue;
static QueueHandle_t result_queue;

static volatile uint32_t verification_ok = 0U;

static int32_t sum_c(const int32_t *values, uint32_t length)
{
    int32_t sum = 0;

    for (uint32_t i = 0U; i < length; ++i) {
        sum += values[i];
    }

    return sum;
}

static int32_t max_c(const int32_t *values, uint32_t length)
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
        (void)xQueueSend(job_queue, &job, portMAX_DELAY);
        vTaskDelay(pdMS_TO_TICKS(1000U));
    }
}

static void processor_task(void *argument)
{
    (void)argument;

    array_job_t job;

    for (;;) {
        if (xQueueReceive(job_queue, &job, portMAX_DELAY) == pdPASS) {
            array_result_t result = {
                job.values,
                job.length,
                riscv_array_sum(job.values, job.length),
                riscv_array_max(job.values, job.length)
            };

            (void)xQueueSend(result_queue, &result, portMAX_DELAY);
        }
    }
}

static void verifier_task(void *argument)
{
    (void)argument;

    array_result_t result;

    for (;;) {
        if (xQueueReceive(result_queue, &result, portMAX_DELAY) == pdPASS) {
            const int32_t expected_sum = sum_c(result.values, result.length);
            const int32_t expected_max = max_c(result.values, result.length);

            verification_ok =
                (result.sum_asm == expected_sum) &&
                (result.max_asm == expected_max);
        }
    }
}

int main(void)
{
    job_queue = xQueueCreate(2U, sizeof(array_job_t));
    result_queue = xQueueCreate(2U, sizeof(array_result_t));

    if ((job_queue == NULL) || (result_queue == NULL)) {
        for (;;) {
        }
    }

    (void)xTaskCreate(
        producer_task, "Producer",
        configMINIMAL_STACK_SIZE, NULL,
        tskIDLE_PRIORITY + 1U, NULL
    );

    (void)xTaskCreate(
        processor_task, "Processor",
        configMINIMAL_STACK_SIZE, NULL,
        tskIDLE_PRIORITY + 2U, NULL
    );

    (void)xTaskCreate(
        verifier_task, "Verifier",
        configMINIMAL_STACK_SIZE, NULL,
        tskIDLE_PRIORITY + 1U, NULL
    );

    vTaskStartScheduler();

    for (;;) {
    }
}
