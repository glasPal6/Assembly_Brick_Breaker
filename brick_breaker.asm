    org 0x7C00

    %define SCREEN_WIDTH 320
    %define SCREEN_HEIGHT 200

    %define COLOUR_BLACK 0
    %define COLOUR_BLUE 1
    %define COLOUR_GREEN 2
    %define COLOUR_CYAN 3
    %define COLOUR_RED 4
    %define COLOUR_MAGENTA 5
    %define COLOUR_BROWN 6
    %define COLOUR_LIGHTGRAY 7
    %define COLOUR_DRAKGRAY 8
    %define COLOUR_LIGHTBLUE 9
    %define COLOUR_LIGHTGREEN 10
    %define COLOUR_LIGHTCYAN 11
    %define COLOUR_LIGHTRED 12
    %define COLOUR_LIGHTMAGENTA 13
    %define COLOUR_YELLOW 14
    %define COLOUR_WHITE 15

    %define VGA_MEM_OFFSET 0A000h

    %define PADDLE_Y 180
    %define PADDLE_WIDTH 50
    %define PADDLE_HEIGHT 3
    %define PADDLE_VEL 5

    %define BALL_WIDTH 5
    %define BALL_HEIGHT 5
    %define BALL_VELX 1
    %define BALL_VELY 1

struc State
    .time: resb 1
    .paddle_x: resw 1
    ; paddle_y is a constant
    .ball_x: resw 1
    .ball_y: resw 1
    .ball_vel: resb 1
endstruc

; Main program
main:
    call set_graphics
    jmp .draw_paddle

    .loop:
        ; Get system time
        ;mov ah, 2dh
        ;int 0x21
        ;cmp dl, [state + State.time]
        ;je .loop
        ;mov [state + State.time], dl
        ;jmp .draw_paddle

        ; Get key pressed
        mov ah, 0x1
        int 0x16
        jz .loop

    .key_pressed:
        ; Clear the screen
        mov ax, 0x13
        int 0x10

        mov ah, 0
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
        mov ax, PADDLE_VEL
        add [state + State.paddle_x], ax

        jmp .draw_paddle

    .paddle_left:
        ; Decrease paddle_x
        mov ax, PADDLE_VEL
        sub [state + State.paddle_x], ax
    ; NB: Possible fall through
        jmp .draw_paddle

    .draw_paddle:
        ; Draw the paddle
        mov dx, PADDLE_Y
        mov cx, [state + State.paddle_x]
        .draw_paddle_loop:
            ; Draw the width
            mov ah, 0ch
            mov al, COLOUR_GREEN
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
            mov al, COLOUR_RED
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
        .move_ball_x:
            mov ax, [state + State.ball_vel]
            and ax, 01h
            cmp ax, 0
            jz .change_ball_velx_neg
            .change_ball_velx_pos:
                mov ax, BALL_VELX
                add [state + State.ball_x], ax
                jmp .move_ball_y
            .change_ball_velx_neg:
                mov ax, BALL_VELX
                sub [state + State.ball_x], ax

        .move_ball_y:
            mov ax, [state + State.ball_vel]
            shr ax, 1
            cmp ax, 0
            jz .change_ball_vely_neg
            .change_ball_vely_pos:
                mov ax, BALL_VELY
                add [state + State.ball_y], ax
                jmp .check_ball_x
            .change_ball_vely_neg:
                mov ax, BALL_VELY
                sub [state + State.ball_y], ax

        ; Ball bounds logic
        ; if (ball_x <= 0) or (ball_x >= SCREEN_WIDTH - BALL_WIDTH) change ball_velx
        .check_ball_x:
        ;    mov ax, [state + State.ball_x]
        ;    cmp ax, 0
        ;    jle .check_ball_velx
        ;
        ;    mov ax, [state + State.ball_x]
        ;    add ax, BALL_WIDTH
        ;    cmp ax, SCREEN_WIDTH
        ;    jge .check_ball_velx
        ;
        ;    jmp .check_ball_y
        ;
        ;    .check_ball_velx:
        ;        xor byte [state + State.ball_velx], 0fh
        ; if (ball_y <= 0) check ball_vely
        .check_ball_y:
            mov ax, [state + State.ball_y]
            cmp ax, 0
            jg .check_ball_y_bottom
            .check_ball_vely:
                xor byte [state + State.ball_vel], 02h

        ; Check if the ball is off the bottom of the screen
        ; if (ball_y >= SCREEN_HEIGHT - BALL_HEIGHT)
        .check_ball_y_bottom:
        ;    mov ax, [state + State.ball_y]
        ;    add ax, BALL_HEIGHT
        ;    cmp ax, SCREEN_HEIGHT
        ;    jge main
        
        ; Check if the ball is hitting the paddle
        
        jmp .loop

set_graphics:
    ; VGA mode 0x13 - 320x200x256
    mov ax, 0x13
    int 0x10
    ret

state:
istruc State
    at State.time, db 0
    at State.paddle_x, dw 110
    ;at State.ball_x, dw 160
    ;at State.ball_y, dw 100
    at State.ball_x, dw 20
    at State.ball_y, dw 10
    at State.ball_vel, db 0x00 ; up left
    ;at State.ball_vel, db 0x01 ; up right
    ;at State.ball_vel, db 0x02 ; down left
    ;at State.ball_vel, db 0x03 ; down right
iend

; Check if the correct amount of memory is used
; This has to be at the end of the program
memory_check:
    ; Make sure the correct amount of memory is used
    times 510 - ($ - $$) db 0
    dw 0xaa55

