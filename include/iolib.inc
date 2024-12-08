%ifndef IOLIB
%define IOLIB


; ====================================
; Wrapper of the SYS_WRITE
;
; PARAMETERS
; 1 - Pointer of the content to write
; 2 - Size of the content
; 
%macro print 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
;
; ====================================


; ===========================================================
; Wrapper of the SYS_WRITE, also prints a LF (20) at the end
;
; PARAMETERS:
; 1 - Pointer of the content to write
; 2 - Size of the content
; 
%macro println 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall

    push 10

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rax
    xor rax, rax
%endmacro
;
; ===========================================================


; ================================
; Wrapper of the SYS_READ
;
; PARAMETERS:
; 1 - Buffer to receive the input
; 2 - Size of the buffer in bytes
;
%macro input 2
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
;
; ================================


%endif
