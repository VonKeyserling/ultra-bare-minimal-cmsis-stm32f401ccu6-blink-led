#include <stdint.h>

typedef void (*ISR_t)(void);

extern uint32_t _estack;

extern uint32_t _etext;

extern uint32_t _sdata;
extern uint32_t _edata;

extern uint32_t _sbss;
extern uint32_t _ebss;

int main();

void Default_Handler(){
    while (1) {

    }
}

void Reset_Handler(void){
    uint32_t *source_data = &_etext;
    uint32_t *destination_data = &_sdata;

    while (destination_data < &_edata) {
        *destination_data++ = *source_data++;
    }

    source_data = &_sbss;

    while (source_data < &_ebss) {
        *source_data++ = 0;
    }

    main();
}

ISR_t isr_vector[] __attribute__((section(".isr_vector"))) = {
    (ISR_t)&_estack,
    Reset_Handler,
};
