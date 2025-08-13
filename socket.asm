; Socket
; Compile with: nasm -f elf socket.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 socket.o -o socket
; Run with: ./socket
; Run in another terminal: curl http://localhost:9001

%include        'functions.asm'

SECTION .data                   ; response string
response    db      'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello World!', 0Dh, 0Ah, 0h

SECTION .bss
buffer      resb    255,        ; variable to store request headers

SECTION .text
global  _start
_start:
    xor     eax, eax            ; init eax 0
    xor     ebx, ebx            ; init ebx 0
    xor     edi, edi            ; init edi 0
    xor     esi, esi            ; init esi 0

_socket:
    push    byte 6              ; push 6 onto the stack (IPPROTO_TCP)
    push    byte 1              ; push 1 onto the stack (SOCK_STREAM)
    push    byte 2              ; push 2 onto the stack (PF_INET)
    mov     ecx, esp            ; move address of arguments into ECX
    mov     ebx, 1              ; invoke subroutine SOCKET (1)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h                 ; interrupt, call the kernel

_bind:
    mov     edi, eax            ; move return value of SYS_SOCKETCALL into edi (file descriptor for new socket, or -1 on error)
    push    dword 0x00000000    ; push 0 dec onto the stack IP ADDRESS (0.0.0.0)
    push    word 0x2923         ; push 9001 dec onto stack PORT (reverse byte order)
    push    word 2              ; push 2 dec onto stack AF_INET
    mov     ecx, esp            ; move address of stack pointer into ecx
    push    byte 16             ; push 16 dec onto stack (arguments length)
    push    ecx                 ; push the address of arguments onto stack
    push    edi                 ; push the file descriptior onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 2              ; invoke subroutine BIND (2)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h

_listen:
    push    byte 1              ; move 1 onto stack (max queue length argument)
    push    edi                 ; push the file descriptor onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 4              ; invoke subroutine LISTEN (4)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h

_accept:
    push    byte 0              ; push 0 dec onto stack (address length argument)
    push    byte 0              ; push 0 dec onto stack (address argument)
    push    edi                 ; push the file descriptor onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 5              ; invoke subroutine ACCEPT (5)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h

_fork:
    mov     esi, eax            ; move return value of SYS_SOCKETCALL into esi (file descriptor for accepted socket, or -1 on error)
    mov     eax, 2              ; invoke SYS_FORK (kernel opcode 2)
    int     80h

    cmp     eax, 0              ; if return value of SYS_FORK in eax is zero we are in the child process
    jz      _read

    jmp     _accept

_read:
    mov     edx, 255            ; number of bytes to read (we will only read the first 255 bytes for simplicity)
    mov     ecx, buffer         ; move the memory address of our buffer variable into ecx
    mov     ebx, esi            ; move esi into ebx (accepted socket file descriptor)
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h

    mov     eax, buffer         ; move the memory address of our buffer variable into eax for printing
    call    sprintLF

_write:
    mov     edx, 78             ; move 78 dec into edx (length in bytes to write)
    mov     ecx, response
    mov     ebx, esi            ; move file descriptor into ebx (accepted socket id)
    mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h

_close:
    mov     ebx, esi            ; move esi into ebx (accepted socket file descriptor)
    mov     eax, 6              ; invoke SYS_CLOSE (kernel opcode 6)
    int     80h

_exit:
    call    quit