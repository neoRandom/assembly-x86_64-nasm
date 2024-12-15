%ifndef MMRLIB_REMOVE_STACK_FRAME
%define MMRLIB_REMOVE_STACK_FRAME


; ================================================================
; Removes the Stack Frame
;
; Note: Gets the size allocated with POP
;
%macro remove_stack_frame 1
    pop rbp
    add rsp, rbp
    pop rbp
%endmacro
;
; ================================================================


%endif
