[ORG 0x500]

[SECTION .text]
[BITS 16]

global _start
_start:


;框架





;框架

    mov si,jump_to_setup
    call    print

        jmp     $



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
    db "jump to setup succes!", 10, 13, 0
