# Assembly Brick Breaker

## Overview

Assembly Brick Breaker is a bootable program written in x86 Assembly using NASM. It leverages the bootloader to load directly onto an Intel architecture CPU. The program runs directly on the hardware, bypassing the operating system, which imposes strict size limits of 512 bytes for the boot sector code. Inspired by [pinpog](https://github.com/tsoding/pinpog.git).

## Special Features

- Operates as a bootloader-compatible executable.
- Can boot on any Intel CPU without requiring an operating system.
- Fully self-contained, working within the smallest necessary footprint.

![Gameplay](gameplay.gif)

## Dependencies

- [NASM] - The Netwide Assembler
- [QEMU] - Processor Emulator to test the binary

## Quick Start

Build and run the program:
```console
make run
```

For more minimal environments:
- Build the binary directly:
  ```bash
  nasm brick_breaker.asm -o brick_breaker
  ```

## Controls

- `N`, `E`: Move paddle sideways
- `F`: Restart the game
- `Space`: Toggle pause

## Bootable USB

This program can be written to a USB for direct boot. As it occupies less than the boot sector's limit (512 bytes), it can easily be loaded in low-level environments. **Use at your own risk. Improperly writing to a USB can damage your system setup.**

### Steps:
1. Build the binary:
   ```bash
   make brick_breaker
   ```
2. Plug in a USB stick.
3. Find your USB block device:
   ```bash
   lsblk
   ```
4. Write the binary to the USB drive:
   ```bash
   sudo dd if=./brick_breaker of=/dev/<usb-drive>
   ```
   Be cautious; replacing `<usb-drive>` with an incorrect drive name can damage your system.

5. Boot your system from the USB to start the game.

## TODO

1. Add scoring for paddle bounces and render to the screen.
2. Implement game over logic when the ball hits the bottom.
3. Add a timer interrupt (0x70).
4. Optimize rectangle drawing using pointer registers.
5. Introduce breakable bricks if space allows.

## Resources

- [x86 and amd64 Instruction Reference](https://www.felixcloutier.com/x86/index.html)
- [VGA Modes and Memory](https://wiki.osdev.org/Drawing_In_a_Linear_Framebuffer)
- [Interrupt 10h Documentation](https://stanislavs.org/helppc/int_10.html)
- [Timer Interrupts Overview](http://www.ctyme.com/intr/rb-2703.htm)

## Note

This program complies with the constraints for boot sector code. Designed to fit within 512 bytes, it is directly compatible with the bootloader requirements on Intel CPUs.
