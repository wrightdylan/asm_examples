; Execute
; Compile with: nasm -f elf execute.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 execute.o -o execute
; Run with: ./execute

%include        'functions.asm'

SECTION .data
command         db      '/bin/echo', 0h
arg1            db      'Hello World!', 0h
arguments       dd      command
                dd      arg1
                dd      0h
environment     dd      0h

SECTION .text
global  _start
_start:
    mov     edx, environment
    mov     ecx, arguments
    mov     ebx, command
    mov     eax, 11             ; invoke SYS_EXECUTE (kernel opcode 11)
    int     80h

    call    quit