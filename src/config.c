#include "config.h"


void init_uart(UART_HandleTypeDef* uart){ 
  __USART2_CLK_ENABLE();
  uart->Instance        = USART2;
  uart->Init.BaudRate   = 115200;
  uart->Init.WordLength = UART_WORDLENGTH_8B;
  uart->Init.StopBits   = UART_STOPBITS_1;
  uart->Init.Parity     = UART_PARITY_NONE;
  uart->Init.Mode       = UART_MODE_TX_RX;
    
    if (HAL_UART_Init(uart) != HAL_OK)
        asm("bkpt 255");
}

void init_gpio(GPIO_InitTypeDef* gpio){
  __GPIOA_CLK_ENABLE();
 
    gpio->Pin = GPIO_PIN_2;
    gpio->Mode = GPIO_MODE_AF_PP;
    gpio->Alternate = GPIO_AF7_USART2;
    gpio->Speed = GPIO_SPEED_HIGH;
    gpio->Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOA, gpio);
    
    gpio->Pin = GPIO_PIN_3;
    gpio->Mode = GPIO_MODE_AF_OD;
    HAL_GPIO_Init(GPIOA, gpio);

}
