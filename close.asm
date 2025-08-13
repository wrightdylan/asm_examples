; Close
; Compile with: nasm -f elf close.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 close.o -o close
; Run with: ./close

; Mode          Description                         Value
; O_RDONLY      open file in read only mode         0
; O_WRONLY      open file in write only mode        1
; O_RDWR        open file in read and write mode    2

%include        'functions.asm'

SECTION .data
filename    db      'readme.txt', 0h
contents    db      'Hello World!', 0h

SECTION .bss
fileContets     resb    255,

SECTION .text
global  _start
_start:
    mov     ecx, 0777o
    mov     ebx, filename
    mov     eax, 8          ; invoke SYS_CREAT (kernel opcode 8)
    int     80h             ; interrupt with sys call

    mov     edx, 12         ; number of bytes to write - one for each letter of the string
    mov     ecx, contents
    mov     ebx, eax
    mov     eax, 4          ; invoke SYS_WRITE (kerne opcode 4)
    int     80h

    mov     ecx, 0          ; flag for read only access mode (O_RDONLY)
    mov     ebx, filename
    mov     eax, 5
    int     80h

    mov     edx, 12         ; number of bytes to read
    mov     ecx,fileContets ; move the memory address of our file contents variable into ecx
    mov     ebx, eax
    mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int     80h

    mov     eax, fileContets
    call    sprintLF

    mov     ebx, ebx        ; not needed but used to demonstrate that SYS_CLOSE takes a file descriptor from EBX
    mov     eax, 6          ; invoke SYS_CLOSE (kernel opcode 6)
    int     80h

    call    quit