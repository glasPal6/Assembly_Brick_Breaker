
.PHONY: all
all: brick_breaker.asm
	nasm brick_breaker.asm -o brick_breaker

.PHONY: run
run: all
	qemu-system-i386 -monitor stdio brick_breaker

.PHONY: clean
clean:
	rm brick_breaker
