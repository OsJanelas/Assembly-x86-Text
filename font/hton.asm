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
    cmp al, 'H'
    je .fH
    cmp al, 'I'
    je .fI
    cmp al, 'J'
    je .fJ
    cmp al, 'K'
    je .fK
    cmp al, 'L'
    je .fL
    cmp al, 'M'
    je .fM
    cmp al, 'N'
    je .fN
    cmp al, 'h'
    je .fh_min
    cmp al, 'i'
    je .fi_min
    cmp al, 'j'
    je .fj_min
    cmp al, 'k'
    je .fk_min
    cmp al, 'l'
    je .fl_min
    cmp al, 'm'
    je .fm_min
    cmp al, 'n'
    je .fn_min
    stc
    ret

.fH: 
    mov si, font_H 
    clc 
    ret
.fI: 
    mov si, font_I 
    clc 
    ret
.fJ: 
    mov si, font_J 
    clc 
    ret
.fK: 
    mov si, font_K 
    clc 
    ret
.fL: 
    mov si, font_L 
    clc 
    ret
.fM:
    mov si, font_M
    clc
    ret
.fN:
    mov si, font_N
    clc
    ret
.fh_min: 
    mov si, font_h_min 
    clc 
    ret
.fi_min: 
    mov si, font_i_min 
    clc 
    ret
.fj_min: 
    mov si, font_j_min 
    clc 
    ret
.fk_min: 
    mov si, font_k_min 
    clc 
    ret
.fl_min: 
    mov si, font_l_min 
    clc 
    ret
.fm_min:
    mov si, font_m_min
    clc
    ret
.fn_min:
    mov si, font_n_min
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
font_H: db 0x66, 0x66, 0x66, 0x7E, 0x66, 0x66, 0x66, 0x00
font_I: db 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x00
font_J: db 0x7E, 0x06, 0x06, 0x06, 0x06, 0x66, 0x3C, 0x00
font_K: db 0x66, 0x66, 0x66, 0x7C, 0x66, 0x66, 0x66, 0x00
font_L: db 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x7E, 0x00
font_M: db 0x66, 0x7E, 0x7E, 0x66, 0x66, 0x66, 0x66, 0x00
font_N: db 0x7E, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x00

; LOWERCASE
font_h_min: db 0x60, 0x60, 0x7C, 0x66, 0x66, 0x66, 0x66, 0x00
font_i_min: db 0x60, 0x00, 0x60, 0x60, 0x60, 0x60, 0x60, 0x00
font_j_min: db 0x06, 0x00, 0x06, 0x06, 0x06, 0x66, 0x3C, 0x00
font_k_min: db 0x60, 0x60, 0x66, 0x7C, 0x66, 0x66, 0x66, 0x00
font_l_min: db 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x70, 0x00
font_m_min: db 0x00, 0x00, 0x7E, 0x7E, 0x7E, 0x66, 0x66, 0x00
font_n_min: db 0x00, 0x00, 0x7E, 0x66, 0x66, 0x66, 0x66, 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55