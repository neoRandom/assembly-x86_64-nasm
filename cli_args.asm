%include "include/essential.inc"
%include "include/mathlib/module.inc"
%include "include/stringlib/string_len.inc"
%include "include/stringlib/number_to_string.inc"
%include "include/iolib/print.inc"
%include "include/iolib/println.inc"

section .data
    argc_label db "Argument(s): ", 0
    argv_label db "Argument #", 0
    splitter db ": ", 0

section .text
    global _start

_start:
    ; Printing the argc
    mov rax, [rsp]
    call number_to_string
    mov r15, rax
    print argc_label
    println r15

    ; Printing each argv
    pop r15     ; Number of args
    mov r14, 0  ; Counter
    .print_arg:
        ; Printing the label
        print argv_label
        
        ; Printing the number
        mov rax, r14            ; Setting RAX (number to be converted) as r14 (counter)
        inc rax                 ; Incrementing by one, so the count starts in 1
        call number_to_string  ; Converting the number to string
        mov r13, rax            ; Saving the pointer
        print r13

        ; Printing the splitter
        print splitter

        ; Printing the arg value
        pop r13
        println r13

        ; End of repetition
        inc r14
        cmp r14, r15
        jne .print_arg

    exit 0
