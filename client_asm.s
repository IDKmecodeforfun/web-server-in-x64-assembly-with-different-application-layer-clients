.intel_syntax noprefix
.global _start

.section .text

_start:
    # setting up the value for the server identification
    push 0x00
    sub rsp, 0x04
    mov dword ptr [rsp], 0x00
    push word ptr 0x901f
    push word ptr 0x0002

loop:
    # creating a socket
    mov rdi, 0x02
    mov rsi, 0x01
    mov rdx, 0x00
    mov rax, 0x29
    syscall

    # socket fd
    mov r12, rax

    # connecting to a server
    mov rdi, r12
    mov rsi, rsp
    mov rdx, 0x10
    mov rax, 0x2a
    syscall

    # creating a fork syscall
    mov rax, 0x39 
    syscall

    # checking if its child or not
    cmp rax, 0x00
    je child_process

    # creating a new client while also closing the socket first
    mov rdi, r12
    mov rax, 0x03
    syscall
    jmp loop

child_process:
    # allocate memory
    sub rsp, 0x1000
    
    # sending the static request to the server
    mov rdi, r12
    lea rsi, [static_get_request]
    mov rdx, 0x12 
    mov rax, 0x01
    syscall

    # reading the response
    mov rdi, r12
    mov rsi, rsp
    mov rdx, 0x1000
    mov rax, 0x00
    syscall
    
    # writing out the response in terminal
    mov rdi, 0x01
    mov rsi, rsp
    mov rdx, rax
    mov rax, 0x01
    syscall
    
    # close the client
    mov rdi, r12
    mov rax, 0x03
    syscall

    # reset stack    
    add rsp, 0x1000

    # close the child process
    xor rdi, rdi
    mov rax, 0x3c
    syscall

.section .data

static_get_request:
    .ascii "GET / HTTP/1.1\r\n\r\n"

