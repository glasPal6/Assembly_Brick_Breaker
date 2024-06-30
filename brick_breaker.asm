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
    %define PADDLE_VEL 5

    %define BALL_WIDTH 3
    %define BALL_HEIGHT 3
    %define BALL_VELX 1
    %define BALL_VELY 1

struc State
    .paddle_x: resw 1
    ; paddle_y is a constant
    .ball_x: resw 1
    .ball_y: resw 1
    .ball_velx: resw BALL_VELX
    .ball_vely: resw BALL_VELY
endstruc

; Main program
main:
    call set_graphics
    jmp .draw_paddle

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
        jmp .draw_paddle

    .paddle_right: 
        ; Increase paddle_x
        mov ax, [state + State.paddle_x]
        add ax, PADDLE_VEL
        mov [state + State.paddle_x], ax

        jmp .draw_paddle

    .paddle_left:
        ; Decrease paddle_x
        mov ax, [state + State.paddle_x]
        sub ax, PADDLE_VEL
        mov [state + State.paddle_x], ax
    ; NB: Possible fall through
        jmp .draw_paddle

    .draw_paddle:
        ; Clear the screen    
        mov ax, 0x13
        int 0x10
        ; Draw the paddle
        mov dx, PADDLE_Y
        mov cx, [state + State.paddle_x]
        .draw_paddle_loop:
            ; Draw the width
            mov ah, 0ch
            mov al, COLOR_GREEN
            int 0x10
            inc cx
            mov ax, cx
            sub ax, [state + State.paddle_x]
            cmp ax, PADDLE_WIDTH
            jng .draw_paddle_loop
            
            ; Draw the height
            mov cx, [state + State.paddle_x]
            inc dx
            mov ax, dx
            sub ax, PADDLE_Y
            cmp ax, PADDLE_HEIGHT
            jng .draw_paddle_loop

    .draw_ball:
        ; Draw the ball
        mov dx, [state + State.ball_y]
        mov cx, [state + State.ball_x]
        .draw_ball_loop:
            ; Draw the width
            mov ah, 0ch
            mov al, COLOR_RED
            int 0x10
            inc cx
            mov ax, cx
            sub ax, [state + State.ball_x]
            cmp ax, BALL_WIDTH
            jng .draw_ball_loop

            ; Draw the height
            mov cx, [state + State.ball_x]
            inc dx
            mov ax, dx
            sub ax, [state + State.ball_y]
            cmp ax, BALL_HEIGHT
            jng .draw_ball_loop

        ; Move the ball
        mov ax, [state + State.ball_x]
        add ax, [state + State.ball_velx]
        mov [state + State.ball_x], ax
        mov ax, [state + State.ball_y]
        add ax, [state + State.ball_vely]
        mov [state + State.ball_y], ax
        
        jmp .loop

set_graphics:
    ; VGA mode 0x13 - 320x200x256
    mov ax, 0x13
    int 0x10
    ret

state:
istruc State
    at State.paddle_x, dw 110
    at State.ball_x, dw 160
    at State.ball_y, dw 100
    at State.ball_velx, dw 1
    at State.ball_vely, dw 1
iend

; Check if the correct amount of memory is used
; This has to be at the end of the program
memory_check:
    ; Make sure the correct amount of memory is used
    times 510 - ($ - $$) db 0
    dw 0xaa55

