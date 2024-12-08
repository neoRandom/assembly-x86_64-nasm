%include "macro_include.asm"

section .data
    hello db "Hello, world!", 10

section .text
    global _start

_start:
    print hello, 14

    mov rax, 999
    reset_reg rax

    mov rax, 999
    reset_reg rax

    exit
