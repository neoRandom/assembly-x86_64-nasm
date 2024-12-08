%ifndef IOLIB
%define IOLIB

%macro print 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

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

%macro input 2
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%endif
