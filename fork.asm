; Fork
; Compile with: nasm -f elf fork.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 fork.o -o fork
; Run with: ./fork

%include        'functions.asm'

SECTION .data
childMsg        db      'This is the child process', 0h
parentMsg       db      'This is the parent process', 0h

SECTION .text
global  _start
_start:
    mov     eax, 2      ; invoke SYS_FORK (kernel opcode 2)
    int     80h

    cmp     eax, 0
    jz      child

parent:
    mov     eax, parentMsg
    call    sprintLF

    call    quit

child:
    mov     eax, childMsg
    call    sprintLF

    call    quit