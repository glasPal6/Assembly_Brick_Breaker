    org 0x7C00

    %define SCREEN_WIDTH 320
    %define SCREEN_HEIGHT 200

    %define COLOR_BLACK 0
    %define COLOR_BLUE 1
    %define COLOR_GREEN 2
    %define COLOR_CYAN 3
    %define COLOR_RED 4
    %define COLOR_MAGENTA 5
    %define COLOR_BROWN 6
    %define COLOR_LIGHTGRAY 7
    %define COLOR_DRAKGRAY 8
    %define COLOR_LIGHTBLUE 9
    %define COLOR_LIGHTGREEN 10
    %define COLOR_LIGHTCYAN 11
    %define COLOR_LIGHTRED 12
    %define COLOR_LIGHTMAGENTA 13
    %define COLOR_YELLOW 14
    %define COLOR_WHITE 15

    %define VGA_MEM_OFFSET 0A000h

    %define PADDLE_Y 150
    %define PADDLE_WIDTH 50
    %define PADDLE_HEIGHT 5

struc State
    .paddle_x: resw 1
    ; paddle_y is a constant
endstruc

state:
istruc State
    at State.paddle_x, dw 50
iend

; Main program
main:
    call set_graphics
    jmp .draw_paddle_initial

    .loop:
        ; Get key pressed
        mov ah, 0x1
        int 0x16
        jz .loop

        xor ah, ah
        int 0x16
        
        ; Possible keys
        cmp al, 'e'
        jz .paddle_right

        cmp al, 'n'
        jz .paddle_left

        cmp al, 'f'
        jz main
    
        ; No key pressed
        jmp .loop

    .paddle_right:
        ; Increase paddle_x
        jmp .draw_paddle

    .paddle_left:
        ; Decrease paddle_x
    ; NB: Potential fall through
        jmp .draw_paddle

    .draw_paddle:
        jmp .loop

    .draw_paddle_initial:
        mov dx, PADDLE_Y
        mov cx, [state + State.paddle_x]
        .draw_paddle_initial_loop:
            ; Draw the width
            mov ah, 0ch
            mov al, COLOR_GREEN
            int 0x10
            inc cx
            mov ax, cx
            sub ax, [state + State.paddle_x]
            cmp ax, PADDLE_WIDTH
            jng .draw_paddle_initial_loop
            
            ; Draw the height
            mov cx, [state + State.paddle_x]
            mov ax, dx
            sub ax, PADDLE_Y
            cmp ax, PADDLE_HEIGHT
            jng .draw_paddle_initial_loop
        jmp .loop

set_graphics:
    ; VGA mode 0x13 - 320x200x256
    mov ax, 0x13
    int 0x10
    ret

; Check if the correct amount of memory is used
; This has to be at the end of the program
memory_check:
    ; Make sure the correct amount of memory is used
    times 510 - ($ - $$) db 0
    dw 0xaa55

