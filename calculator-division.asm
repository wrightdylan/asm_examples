; Calculator (Division)
; Compile with: nasm -f elf calculator-division.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 calculator-division.o -o calculator-division
; Run with: ./calculator-division

%include        'functions.asm'

SECTION .data
msg1        db      ' remainder '

SECTION .text
global  _start
_start:
    mov     eax, 90
    mov     ebx, 9
    div     ebx
    call    iprint
    mov     eax, msg1
    call    sprint
    mov     eax, edx
    call    iprintLF

    call    quit