; Hello World Program (External file include)
; Compile with: nasm -f elf helloworld-inc.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld-inc.o -o helloworld-inc
; Run with: ./helloworld-inc
%include        'functions.asm'

SECTION .data
msg1    db      'Hello, brave new world!', 0h           ; first message string with null terminator
msg2    db      'This is how we recycle in NASM', 0h    ; second message string with null terminator

SECTION .text
global _start
_start:
    mov     eax, msg1
    call    sprintLF

    mov     eax, msg2
    call    sprintLF

    call    quit