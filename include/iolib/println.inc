%ifndef IOLIB_PRINTLN
%define IOLIB_PRINTLN


; ================================================================
; Wrapper of the (private) function __println
;
; PARAMETERS:
; 1 - Pointer of the content to write
; 
%macro println 1
    ; Setting the parameters
    push %1
    call __println
    pop rax
%endmacro
;
; ================================================================


; ================================================================
; Is like __print, but also prints a LF (20) at the end
;
; DEPENDENCIES: 'string_len' from 'stringlib'
; PARAMETERS:
; 1 - Pointer of the content to write
; 
__println:
    ; Getting the size of the string
    mov rax, [rsp+8]
    call string_len
    mov rdx, rax

    ; Printing the string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, [rsp+8]
    syscall

    ; Printing the new line
    push 10
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax

    ret
;
; ================================================================


%endif
