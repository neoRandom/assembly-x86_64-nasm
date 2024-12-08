%include "include/essential.inc"
%include "include/mathlib.inc"
%include "include/outlib.inc"


section .text
    global _start

_start:
    pop rax
    call _number_to_string
    push rax

    println [rsp], 1

    exit 0
