%ifndef MMRLIB_GET_PARAM
%define MMRLIB_GET_PARAM


; ================================================================
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
; ================================================================


%endif
