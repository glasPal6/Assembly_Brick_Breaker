# Assembly Brick Breaker

## Overview

Programed in x86 assembly using NASM. Can use QEMU to run the program. The goal is to limit it to 512 bytes so that it fits within the bootloader. Inspired by [pinpog](https://github.com/tsoding/pinpog.git).

*The project is archived at the moment, till I have time to work on it*

## Dependencies

- [nasm]
- [qemu]

## Quick Start

Build and run the program:
```console
make run
```

## Controls

- `n`, `e`: move racket sideways,
- `f`: restart the game,
- `space`: toggle pause.

## Linux Bootable USB stick

[!Warning] - This could destroy your computer. Please use at your own risk.

1. Build the image of the game: `$ make brick_breaker`
2. Get a USB stick (at least 512 bytes Kappa)
4. Get the USB block device [lsblk](https://linux.die.net/man/8/lsblk)
5. Use [dd](https://linux.die.net/man/1/dd) to dump the image to the USB drive: `sudo dd if=./brick_breaker of=/dev/<usb-drive>`. Be careful with the drive name.

## TODO

1. Score for a paddle bounce. And draw to the screen.
2. Game over if it hits the bottom. Make it reload the initial state.
3. Add a timer. Look at the timer interupt at 0070h.
4. Make the drawing of the rectangles more efficient. Use multiple inputs and pointer registers.
5. Add a brick to break and change scoring to that - if there is space left in the sector.

## Resources

- [x86 and amd64 istruction reference](https://www.felixcloutier.com/x86/index.html)
- [x86 and amd64 register reference Link 1](https://www.eecg.utoronto.ca/~amza/www.mindsec.com/files/x86regs.html)
- [x86 and amd64 register reference Link 2](https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture)


- [VGA Modes and Memory](https://wiki.osdev.org/Drawing_In_a_Linear_Framebuffer)
- [Interupt 10h Link 1](http://www.ctyme.com/intr/int-10.htm)
- [Interupt 10h Link 2 go to *int 10,0*](https://stanislavs.org/helppc/int_10.html)


- [Keyboard Interupts Link 1](http://www.ctyme.com/intr/int-16.htm)
- [Keyboard Interupts 16h Link 2 go to *int 16,x*](https://stanislavs.org/helppc/int_16.html)


- [Timer Interupts Link 1](http://www.ctyme.com/intr/rb-2703.htm)
- [Timer Interupts Link 2](https://stanislavs.org/helppc/int_21.html)

