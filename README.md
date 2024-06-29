# Assembly Brick Breaker

## Overview

Programed in x86 assembly using NASM. Can use QEMU to run the program. The goal is to limit it to 512 bytes.

## Dependencies

- [nasm]
- [qemu]

## Quick Start

Build and run the program:
```console
$ nasm brick_breaker.asm -o brick_breaker
$ qemu-system-x86_64 brick_breaker
```

## Controls

- `m`, `p`: move racket sideways,
- `r`: restart the game,
- `space`: toggle pause.

## Linux Bootable USB stick

[!Warning] - This could destroy your computer. Please use at your own risk.

1. Build the image of the game: `$ make brick_breaker`
2. Get a USB stick (at least 512 bytes Kappa)
4. Get the USB block device [lsblk](https://linux.die.net/man/8/lsblk)
5. Use [dd](https://linux.die.net/man/1/dd) to dump the image to the USB drive: `sudo dd if=./brick_breaker of=/dev/<usb-drive>`. Be careful with the drive name.

## Resources

- [x86 and amd64 istruction reference](https://www.felixcloutier.com/x86/index.html)
- [x86 and amd64 register reference Link 1](https://www.eecg.utoronto.ca/~amza/www.mindsec.com/files/x86regs.html)
- [x86 and amd64 register reference Link 2](https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture)

- [VGA Modes and Memory](https://wiki.osdev.org/Drawing_In_a_Linear_Framebuffer)
- [Interupt 10h Link 1](http://www.ctyme.com/intr/int-10.htm)
- [Interupt 10h Link 2 go to *int 10,0*](https://stanislavs.org/helppc/int_10.html)
- [Keyboard Interupts Link 1](http://www.ctyme.com/intr/int-16.htm)
- [KeyboardI nterupt 16h Link 2 go to *int 16,x*](https://stanislavs.org/helppc/int_16.html)

