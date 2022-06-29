
#ifndef _CONFIG_H
#define _CONFIG_H
#include "stm32f4xx.h"

/*
    Configure functions in "src/config.c" to adapt your board
*/

void init_uart(UART_HandleTypeDef* uart);

void init_gpio(GPIO_InitTypeDef* gpio);

#endif