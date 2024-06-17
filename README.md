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


