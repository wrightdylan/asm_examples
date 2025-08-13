; Hello World (length)
; Compile with: nasm -f elf helloworld-len.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld-len.o -o helloworld-len
; Run with: ./helloworld-len

SECTION .data
msg     db      'Hello, brave new world!',  0Ah ; assign string to variable

SECTION .text
global _start
_start:
    mov     eax, msg        ; move the message string into EAX
    call    strlen          ; call the function to calculate length

    mov     edx, eax        ; leave the result in EAX
    mov     ecx, msg        ; move the message string into EBX
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h

strlen:
    push    ebx             ; first function declaration
    mov     ebx, eax        ; move address in EAX into EBX (both point to the same segment in memory)

nextchar:
    cmp     byte [eax], 0   ; compare byte pointed to by EAX against zero (end of string delimiter)
    jz      finished        ; jump if zero
    inc     eax             ; increment the address in EAX by one byte (if zero flag not set)
    jmp     nextchar        ; jump to the point in the code labeled 'nextchar'

finished:
    sub     eax, ebx        ; subtract the address in EBX from the address in EAX, resulting in the number of segments (bytes)
    pop     ebx             ; pop the value on the stack back into EBX
    ret