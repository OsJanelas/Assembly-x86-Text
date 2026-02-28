[org 0x7c00]

mov ax, 0x0013
int 0x10

mov word [cursor_x], 10
mov word [cursor_y], 10

main_loop:
    mov ah, 0x00
    int 0x16
    call get_font_ptr
    jc main_loop

    call draw_char

    add word [cursor_x], 9
    cmp word [cursor_x], 300
    jl main_loop
    mov word [cursor_x], 10
    add word [cursor_y], 10
    jmp main_loop

get_font_ptr:
    cmp al, 'V'
    je .fV
    cmp al, 'W'
    je .fW
    cmp al, 'X'
    je .fX
    cmp al, 'Y'
    je .fY
    cmp al, 'Z'
    je .fZ
    cmp al, 'v'
    je .fv_min
    cmp al, 'w'
    je .fw_min
    cmp al, 'x'
    je .fx_min
    cmp al, 'y'
    je .fy_min
    cmp al, 'z'
    je .fz_min
    stc
    ret

.fV: 
    mov si, font_V
    clc 
    ret
.fW: 
    mov si, font_W
    clc 
    ret
.fX: 
    mov si, font_X
    clc 
    ret
.fY: 
    mov si, font_Y
    clc 
    ret
.fZ: 
    mov si, font_Z
    clc 
    ret
.fv_min: 
    mov si, font_v_min 
    clc 
    ret
.fw_min: 
    mov si, font_w_min 
    clc 
    ret
.fx_min: 
    mov si, font_x_min 
    clc 
    ret
.fy_min: 
    mov si, font_y_min 
    clc 
    ret
.fz_min: 
    mov si, font_z_min 
    clc 
    ret

draw_char:
    pusha
    mov cx, 0
.loop_y:
    mov bl, [si]
    mov dx, 0
.loop_x:
    mov al, bl
    and al, 0x80
    jz .skip_pixel

    mov ah, 0x0C
    mov al, 0x0F
    mov bh, 0
    mov cx, [cursor_x]
    add cx, dx
    push dx
    mov dx, [cursor_y]
    add dx, [esp+2]
    pop dx

    push dx
    push cx
    mov dx, [cursor_y]
    add dx, [line_count]
    mov cx, [cursor_x]
    add cx, [bit_count]
    int 0x10
    pop cx
    pop dx

.skip_pixel:
    shl bl, 1
    inc word [bit_count]
    cmp word [bit_count], 8
    jl .loop_x
    
    mov word [bit_count], 0
    inc si
    inc word [line_count]
    cmp word [line_count], 8
    jl .loop_y
    
    mov word [line_count], 0
    popa
    ret

; --- DATA ---
cursor_x: dw 0
cursor_y: dw 0
bit_count: dw 0
line_count: dw 0

; UPPERCASE
font_V: db 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x18, 0x00
font_W: db 0x66, 0x66, 0x66, 0x66, 0x66, 0x7E, 0x66, 0x00
font_X: db 0x66, 0x66, 0x66, 0x66, 0x18, 0x66, 0x66, 0x00
font_Y: db 0x66, 0x66, 0x66, 0x7E, 0x18, 0x18, 0x18, 0x00
font_Z: db 0x7E, 0x06, 0x06, 0x18, 0x60, 0x60, 0x7E, 0x00

; LOWERCASE
font_v_min: db 0x00, 0x00, 0x66, 0x66, 0x66, 0x66, 0x18, 0x00
font_w_min: db 0x00, 0x00, 0x66, 0x66, 0x66, 0x7E, 0x66, 0x00
font_x_min: db 0x00, 0x00, 0x66, 0x66, 0x18, 0x66, 0x66, 0x00
font_y_min: db 0x66, 0x66, 0x66, 0x7E, 0x06, 0x06, 0x7E, 0x00
font_z_min: db 0x00, 0x00, 0x7E, 0x06, 0x18, 0x60, 0x7E, 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55