[ORG 0x7c00]

[SECTION .data]
BOOT_MAIN_ADDR equ 0x500

[SECTION .text]
[BITS 16]

    xor     ax,ax
    mov     ss,ax
    mov     ds,ax
    mov     es,ax
    mov     fs,ax
    mov     gs,ax
    mov     si,ax
    mov sp,0x7c00

global _start
_start:

    mov ax,3
    int 0x10

;框架

    mov edi,BOOT_MAIN_ADDR
    mov ecx,1
    mov bl,2
    call read_hd



;框架

    mov si,jump_to_setup
    call    print
    jmp BOOT_MAIN_ADDR

        jmp     $

read_hd:
    mov dx,0x1f2
    mov al,bl
    out dx,al
    inc dx
    mov al,cl
    out dx,al
    inc dx
    mov al,ch
    out dx,al
    inc dx
    shr ecx,16
    mov al,cl
    out dx,al 

    inc dx
    shr ecx,8
    and cl,0b1111
    mov al,0b11100000
    or al,cl 
    out dx,al 

    inc dx
    mov al,0x20
    out dx,al

    mov cl,bl
._start_read:
    push cx

    call .wait_hd_prepare
    call .read_hd_data

    pop cx

    loop ._start_read

.return:
    ret

.wait_hd_prepare:
    mov dx,0x1f7

.check:
    in al,dx
    and al,0b00001000
    cmp al,0b00001000
    jnz .check

    ret

.read_hd_data:
    mov dx,0x1f0
    mov cx,256

.read_word:
    in ax,dx
    mov [edi],ax
    add edi,2
    loop .read_word

    ret

 print:
        mov ah,0x0e
        mov bh,0
        mov bl,0x01
.loop:
    mov al,[si]
    cmp al,0
    jz .done
    int 0x10

    inc si
    jmp .loop
.done:
    ret

jump_to_setup:
    db "jump to setup...", 10, 13, 0

times 510 - ($ - $$) db 0
db 0x55, 0xaa