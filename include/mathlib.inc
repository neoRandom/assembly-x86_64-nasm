%ifndef MATHLIB
%define MATHLIB


; ================================================================
; Performs the MOD(ule) operation
;
; NOTE: The values of RAX and RCX needs to be pre-defined
; OUTPUT:
; - RAX as the quotient
; - RDX as the remainder
;
%macro module 0
    mov rdx, 0
    div rcx
%endmacro
;
; ================================================================


; ================================================================
; Performs the MOD(ule) operation with parameters
;
; PARAMETERS:
; 1 - Dividend
; 2 - Divisor
; OUTPUT:
; - RAX as the quotient
; - RDX as the remainder
;
%macro module_p 2
    mov rax, %1
    mov rcx, %2
    mov rdx, 0
    div rcx
%endmacro
;
; ================================================================


%endif
