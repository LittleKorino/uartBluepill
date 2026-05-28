# Makefile - cross-compile for STM32103 bare-metal

CROSS        := arm-none-eabi
CC           := $(CROSS)-gcc
AS           := $(CROSS)-gcc
LD           := $(CROSS)-gcc
OBJCOPY      := $(CROSS)-objcopy

APP_DIR      := app
BOARD_DIR    := board
STARTUP_DIR  := startup/stm32103c8t6
INCLUDE_DIR  := Inc
BUILD_DIR    := build
OUTPUT_DIR   := output
HAL_UART     := hal/uart

SRCS_C       := $(APP_DIR)/main.c \
		$(HAL_UART)/uart.c

SRCS_S       := $(STARTUP_DIR)/start.s

OBJS         := $(patsubst %.c, $(BUILD_DIR)/%.o,$(SRCS_C)) \
		$(patsubst %.s, $(BUILD_DIR)/%.o,$(SRCS_S))

CFLAGS       :=  -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG \
		 -DSTM32 -DSTM32F1 -DSTM32F103xB \
		 -Iinc -O0  -Wall -mthumb \
		 -I$(HAL_UART)

LDFLAGS      :=  -mcpu=cortex-m3 -mthumb -T $(BOARD_DIR)/linker.ld \
		 --specs=nano.specs --specs=nosys.specs -nostartfiles

.PHONY: all clean flash test

all:$(OUTPUT_DIR)/firmware.bin

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/firmware.elf: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

$(OUTPUT_DIR)/firmware.bin: $(BUILD_DIR)/firmware.elf
	@mkdir -p $(OUTPUT_DIR)
	$(OBJCOPY) -O binary $< $@
	@echo " [OK] $(OUTPU_DIR)/firmware.bin"

flash:$(OUTPUT_DIR)/firmware.bin
	st-flash --reset write $<  0x08000000
test:flash
	minicom -b 115200 -D /dev/ttyUSB0
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUTPUT_DIR)
