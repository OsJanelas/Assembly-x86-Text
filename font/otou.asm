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
    cmp al, 'O'
    je .fO
    cmp al, 'P'
    je .fP
    cmp al, 'Q'
    je .fQ
    cmp al, 'R'
    je .fR
    cmp al, 'S'
    je .fS
    cmp al, 'T'
    je .fT
    cmp al, 'U'
    je .fU
    cmp al, 'o'
    je .fo_min
    cmp al, 'p'
    je .fp_min
    cmp al, 'q'
    je .fq_min
    cmp al, 'r'
    je .fr_min
    cmp al, 's'
    je .fs_min
    cmp al, 't'
    je .ft_min
    cmp al, 'u'
    je .fu_min
    stc
    ret

.fO: 
    mov si, font_O 
    clc 
    ret
.fP: 
    mov si, font_P 
    clc 
    ret
.fQ: 
    mov si, font_Q 
    clc 
    ret
.fR: 
    mov si, font_R 
    clc 
    ret
.fS: 
    mov si, font_S
    clc 
    ret
.fT:
    mov si, font_T
    clc
    ret
.fU:
    mov si, font_U
    clc
    ret
.fo_min: 
    mov si, font_o_min 
    clc 
    ret
.fp_min: 
    mov si, font_p_min 
    clc 
    ret
.fq_min: 
    mov si, font_q_min 
    clc 
    ret
.fr_min: 
    mov si, font_r_min 
    clc 
    ret
.fs_min: 
    mov si, font_s_min 
    clc 
    ret
.ft_min:
    mov si, font_t_min
    clc
    ret
.fu_min:
    mov si, font_u_min
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
font_O: db 0x7E, 0x66, 0x66, 0x66, 0x66, 0x66, 0x7E, 0x00
font_P: db 0x7C, 0x66, 0x66, 0x7C, 0x60, 0x60, 0x60, 0x00
font_Q: db 0x7E, 0x66, 0x66, 0x66, 0x66, 0x7E, 0x06, 0x00
font_R: db 0x7C, 0x66, 0x66, 0x7C, 0x66, 0x66, 0x66, 0x00
font_S: db 0x7E, 0x60, 0x60, 0x7E, 0x06, 0x06, 0x7E, 0x00
font_T: db 0x7E, 0x7E, 0x18, 0x18, 0x18, 0x18, 0x18, 0x00
font_U: db 0x66, 0x66, 0x66, 0x66, 0x66, 0x7E, 0x7E, 0x00

; LOWERCASE
font_o_min: db 0x00, 0x00, 0x7E, 0x66, 0x66, 0x66, 0x7E, 0x00
font_p_min: db 0x7C, 0x66, 0x66, 0x66, 0x7C, 0x60, 0x60, 0x00
font_q_min: db 0x3E, 0x66, 0x66, 0x66, 0x3E, 0x06, 0x06, 0x00
font_r_min: db 0x00, 0x00, 0x7C, 0x7C, 0x60, 0x60, 0x60, 0x00
font_s_min: db 0x00, 0x00, 0x7E, 0x60, 0x7E, 0x06, 0x7E, 0x00
font_t_min: db 0x18, 0x7E, 0x18, 0x18, 0x18, 0x18, 0x18, 0x00
font_u_min: db 0x00, 0x00, 0x66, 0x66, 0x66, 0x7E, 0x7E, 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55