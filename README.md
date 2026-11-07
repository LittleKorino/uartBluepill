# uartstm32
**Bare-Metal ARM Cortex-M3 Interrupt-Driven UART for STM32F103C8T6**

## Overview
The `uartstm32` repository provides a bare-metal firmware stack for the STM32F103C8T6 microcontroller (commonly known as the "Blue Pill"). It demonstrates the foundational configuration of an ARM Cortex-M3 system without relying on a Real-Time Operating System (RTOS) or heavy vendor libraries like STM32 HAL. The system executes a custom assembly boot sequence, configures the Advanced Peripheral Bus (APB2), and implements an asynchronous, hardware-triggered Universal Synchronous Asynchronous Receiver Transmitter (USART) echo server.

## Features
* **Bare-Metal Execution:** Operates entirely independently of external operating systems, utilizing a custom assembly startup script (`start.s`) to initialize SRAM and map the vector table.
* **Direct Register Access:** Bypasses bloated abstraction layers by configuring hardware directly via CMSIS register mappings.
* **Interrupt-Driven I/O:** Utilizes the Nested Vectored Interrupt Controller (NVIC) to process UART reception asynchronously, eliminating CPU-blocking polling loops.
* **Custom Linker Configuration:** Precisely maps Flash (`0x08000000`) and SRAM (`0x20000000`) boundaries for the STM32F103xB architecture.
* **Automated Toolchain:** Implements a streamlined `Makefile` for compilation, linking, object copy, and ST-Link flashing.

## Prerequisites

**Hardware Requirements**
* STM32F103C8T6 Development Board ("Blue Pill")
* ST-Link V2 USB Programmer
* USB-to-TTL Serial Adapter (3.3V logic)

**Software Dependencies**
Execute all build commands on a Linux host with the following packages installed:
* `arm-none-eabi-gcc` (GNU Arm Embedded Toolchain)
* `make`
* `stlink-tools` (provides the `st-flash` utility)
* `minicom` (or equivalent serial terminal emulator)

## Hardware Connections

**ST-Link V2 (For Flashing):**
* `3.3V`  -> `3.3V`
* `GND`   -> `GND`
* `SWDIO` -> `SWDIO` (PA13)
* `SWCLK` -> `SWCLK` (PA14)

**USB-to-TTL Adapter (For Serial Communication):**
* `GND` -> `GND`
* `RX`  -> `PA9` (STM32 TX)
* `TX`  -> `PA10` (STM32 RX)

## Quick Start

**1. Build the Firmware**
Execute the `make` command to compile the source tree. This generates the `.o` files in the `build/` directory and outputs the final `firmware.bin` binary into the `output/` directory.
```bash
git clone <repository_url>
cd uartstm32
make all
