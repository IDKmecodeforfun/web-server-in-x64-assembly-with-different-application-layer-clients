.intel_syntax noprefix
.global _start

.section .text

_start:
    # creating the socket for the server
    mov rdi, 0x02
    mov rsi, 0x01
    mov rdx, 0x00
    mov rax, 0x29
    syscall

    # socket fd
    mov r12, rax
   
    # setting up memory for sock_addr (in this case ipv4)
    push 0x00 # 8 bytes 0x00 padding
    sub rsp, 0x04 # moving 0.0.0.0 address to the stack 
    mov dword ptr [rsp], 0x00000000
    push word ptr 0x901f # port number (big endian)
    push word ptr 0x0002 # address family

    # binding the socket with ip and port 
    mov rdi, rax
    mov rsi, rsp
    mov rdx, 0x10
    mov rax, 0x31
    syscall
   
    # listening to the port
    xor rsi, rsi
    mov rax, 0x32
    syscall

loop: 
    # accept the client 
    mov rdi, r12
    mov rsi, 0x00
    mov rdx, 0x00
    mov rax, 0x2b
    syscall

    # client fd
    mov r13, rax

    # showing the parent process
    mov rdi, 0x01
    lea rsi, [parent_message]
    mov rdx, 0x14
    mov rax, 0x01
    syscall
    
    # fork syscall
    mov rax, 0x39     
    syscall
    
    # check if child or parent
    cmp rax, 0x00
    je child_process

    # waiting for the child process
    mov rdi, -0x1
    mov rsi, 0x00
    mov rdx, 0x00
    mov r10, 0x00
    mov rax, 0x3d
    syscall

    # closing the client for the parent process
    mov rdi, r13
    mov rax, 0x03
    syscall

    # keep checking for clients
    jmp loop  

child_process:

    # close the socket
    mov rdi, r12
    mov rax, 0x03
    syscall
   
    # read the client 
    sub rsp, 0x1000
    mov rdi, r13
    mov rsi, rsp
    mov rdx, 0x1000
    mov rax, 0x00
    syscall
    
    # write it out to the terminal
    mov rdi, 0x01 
    mov rsi, rsp
    mov rdx, rax
    mov rax, 0x01
    syscall

    # static responding to client fd
    mov rdi, r13
    lea rsi, [static_response]
    mov rdx, 0x13
    mov rax, 0x01
    syscall

    # message from child
    mov rdi, 0x01
    lea rsi, [child_message]
    mov rdx, 0x19
    mov rax, 0x01
    syscall

    # reset the stack
    add rsp, 0x1000
     
    # closing the client
    mov rdi, r13
    mov rax, 0x03
    syscall

    # exiting the child process    
    xor rdi, rdi
    mov rax, 0x3c
    syscall

.section .data

parent_message:    
    .ascii "incoming client...\n\n" 

child_message:
    .ascii "responding to client...\n\n"

static_response:
    .ascii "HTTP/1.1 200 OK\r\n\r\n" 

