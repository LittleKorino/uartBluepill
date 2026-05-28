#include<stm32f1xx.h>

void uart_echo(void){

    int ch = USART1->DR;
    while (!(USART1->SR & (1 << 7)));
    USART1->DR = (ch & 0xFF);
    if (ch == '\r') {
        while (!(USART1->SR & (1 << 7)));
        USART1->DR = '\n';
    }
}

void USART1_IRQHandler(void){
        if (USART1->SR & (1 << 5)){
                uart_echo();
        }
}

void uart_init(void){
        RCC->APB2ENR |= (1 << 14)| (1 << 2); //Enable USART1 and PortA clock

        GPIOA->CRH &= ~(0xFF << 4); //Setup PA9 as OUTPUT(tx) PA10 as input (Rx)
        GPIOA->CRH |= (0x89 << 4); //10001001

        GPIOA->ODR |= (1 << 10); // Pull up on PA10

        //UART Config
        USART1->CR1 |= (1 << 13) | (1 << 3) | (1 << 2) | (1 << 5);
        USART1->BRR = 0x45;
	NVIC_EnableIRQ(USART1_IRQn);
}

