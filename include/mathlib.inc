%ifndef MATHLIB
%define MATHLIB

section .text
    ; Registers used: RAX, RCX, RDX
    ; input: 
    ; - RAX as the number to be divided
    ; - RCX as the divisor
    ; output: 
    ; - RAX as the quotient
    ; - RDX as the remainder
    _module:
        mov rdx, 0
        div rcx

        ret

%endif
