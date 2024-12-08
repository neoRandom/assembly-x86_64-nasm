; =========================== EQU VALUES
STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

; =========================== MACROS
%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

;%macro <name> <args>
%macro print 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

;labels in macros
%macro reset_reg 1
%%loop:  ; using _ or . instead of %% causes a redefined symbol error
    dec %1
    cmp %1, 0
    jnz %%loop
%endmacro
