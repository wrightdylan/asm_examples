; Calculator (Multiplication)
; Compile with: nasm -f elf calculator-multiplication.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 calculator-multiplication.o -o calculator-multiplication
; Run with: ./calculator-multiplication

%include        'functions.asm'

SECTION .text
global  _start
_start:
    mov     eax, 90
    mov     ebx, 9
    mul     ebx
    call    iprintLF

    call    quit