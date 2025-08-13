; Namespace
; Compile with: nasm -f elf namespace.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 namespace.o -o namespace
; Run with: ./namespace

%include        'functions.asm'

SECTION .data
msg1        db      'Jumping to finished label.', 0h
msg2        db      'Inside subroutine number: ', 0h
msg3        db      'Inside subroutine "finished".', 0h

SECTION .text
global  _start
_start:

subroutineOne:
    mov     eax, msg1
    call    sprintLF
    jmp     .finished

.finished:
    mov     eax, msg2
    call    sprint
    mov     eax, 1
    call    iprintLF

subroutineTwo:
    mov     eax, msg1
    call    sprintLF
    jmp     .finished

.finished:
    mov     eax, msg2
    call    sprint
    mov     eax, 2
    call    iprintLF

    mov     eax, msg1
    call    sprintLF
    jmp     finished

finished:
    mov     eax, msg3
    call    sprintLF
    call    quit