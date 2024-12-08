%ifndef MMRLIB
%define MMRLIB


; ===================================
; Creates a Stack Frame
;
; PARAMETERS:
; 1 - Bytes to allocate to the stack
;
%macro create_stack_frame 1
    push rbp
    mov rbp, rsp
    sub rsp, %1
%endmacro
;
; ===================================


; =======================================================
; Sets RAX as the value of the Nth parameter
;
; NOTES: 
; - The reference is the base pointer (RBP)
; - It will only work if the function have a Stack Frame
; - Every parameter needs to be 8 bytes long
; PARAMETERS:
; 1 - Index of the parameter
;
%macro get_param 1
    mov rax, %1
    add rax, 2
    mul 8
    mov rax, [rbp+rax]
%endmacro
;
; =======================================================


; =================================
; Removes the Stack Frame
;
; PARAMETERS:
; 1 - Bytes allocated to the stack
;
%macro remove_stack_frame 1
    add rsp, %1
    pop rbp
%endmacro
;
; =================================
    
%endif
