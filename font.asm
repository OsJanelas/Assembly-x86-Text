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
    cmp al, '0'
    je .f0
    cmp al, '1'
    je .f1
    cmp al, '2'
    je .f2
    cmp al, '3'
    je .f3
    cmp al, '4'
    je .f4
    cmp al, 'A'
    je .fA
    cmp al, 'B'
    je .fB
    cmp al, 'C'
    je .fC
    cmp al, 'D'
    je .fD
    cmp al, 'E'
    je .fE
    cmp al, 'a'
    je .fa_min
    cmp al, 'b'
    je .fb_min
    cmp al, 'c'
    je .fc_min
    cmp al, 'd'
    je .fd_min
    cmp al, 'e'
    je .fe_min
    stc
    ret
.f0: 
    mov si, font_0 
    clc 
    ret
.f1: 
    mov si, font_1 
    clc 
    ret
.f2: 
    mov si, font_2 
    clc 
    ret
.f3: 
    mov si, font_3 
    clc 
    ret
.f4: 
    mov si, font_4 
    clc 
    ret
.fA: 
    mov si, font_A 
    clc 
    ret
.fB: 
    mov si, font_B 
    clc 
    ret
.fC: 
    mov si, font_C 
    clc 
    ret
.fD: 
    mov si, font_D 
    clc 
    ret
.fE: 
    mov si, font_E 
    clc 
    ret
.fa_min: 
    mov si, font_a_min 
    clc 
    ret
.fb_min: 
    mov si, font_b_min 
    clc 
    ret
.fc_min: 
    mov si, font_c_min 
    clc 
    ret
.fd_min: 
    mov si, font_d_min 
    clc 
    ret
.fe_min: 
    mov si, font_e_min 
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

font_0: db 0x3C, 0x66, 0x6E, 0x7E, 0x76, 0x66, 0x3C, 0x00
font_1: db 0x18, 0x38, 0x18, 0x18, 0x18, 0x18, 0x7E, 0x00
font_2: db 0x3C, 0x66, 0x06, 0x1C, 0x30, 0x60, 0x7E, 0x00
font_3: db 0x3C, 0x66, 0x06, 0x1C, 0x06, 0x66, 0x3C, 0x00
font_4: db 0x0C, 0x1C, 0x3C, 0x6C, 0x7E, 0x0C, 0x0C, 0x00

font_A: db 0x18, 0x3C, 0x66, 0x66, 0x7E, 0x66, 0x66, 0x00
font_B: db 0x7C, 0x66, 0x66, 0x7C, 0x66, 0x66, 0x7C, 0x00
font_C: db 0x3C, 0x66, 0x60, 0x60, 0x60, 0x66, 0x3C, 0x00
font_D: db 0x78, 0x6C, 0x66, 0x66, 0x66, 0x6C, 0x78, 0x00
font_E: db 0x7E, 0x60, 0x60, 0x7C, 0x60, 0x60, 0x7E, 0x00

font_a_min: db 0x00, 0x00, 0x3C, 0x06, 0x3E, 0x66, 0x3E, 0x00
font_b_min: db 0x60, 0x60, 0x7C, 0x66, 0x66, 0x66, 0x7C, 0x00
font_c_min: db 0x00, 0x00, 0x3C, 0x60, 0x60, 0x66, 0x3C, 0x00
font_d_min: db 0x06, 0x06, 0x3E, 0x66, 0x66, 0x66, 0x3E, 0x00
font_e_min: db 0x00, 0x00, 0x3C, 0x66, 0x7E, 0x60, 0x3C, 0x00

times 510-($-$$) db 0
dw 0xAA55