; Seek
; Compile with: nasm -f elf seek.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 seek.o -o seek
; Run with: ./seek

; Mode          Description                 Value
; SEEK_SET      beginning of the file       0
; SEEK_CUR      current file offset         1
; SEEK_END      end of the file             2

%include        'functions.asm'

SECTION .data
filename        db      'readme.txt', 0h
contents        db      '-updated-', 0h

SECTION .text
global  _start
_start:
    mov     ecx, 1          ; flag for write only access mode (O_WRONLY)
    mov     ebx, filename
    mov     eax, 5          ; invoke SYS_OPEN (kernel opcode 5)
    int     80h

    mov     edx, 2          ; whence argument (SEEK_END)
    mov     ecx, 0          ; move the cursor 0 bytes
    mov     ebx, eax        ; move the opened file descriptor into EBX
    mov     eax, 19         ; invoke SYS_LSEEK (kernel opcode 19)
    int     80h

    mov     edx, 9          ; number of bytes to write
    mov     ecx, contents
    mov     ebx, ebx        ; not required
    mov     eax, 4          ; invoke SYS_WRITE (kernel opcode 4)
    int     80h

    call    quit