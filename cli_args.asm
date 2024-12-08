%include "include/essential.asm"
%include "include/mathlib.asm"
%include "include/outlib.asm"


section .bss
    number_to_string_buffer resb 1024

section .text
    global _start

_start:
    pop rax
    call _number_to_string
    push rax

    print [rsp], 1

    exit
