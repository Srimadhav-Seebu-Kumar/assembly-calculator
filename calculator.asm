; Simple Calculator Program in x86-64 Assembly Language
; Supports addition, subtraction, multiplication, and division of integers
; Author: Assembly Calculator Project
; Date: September 17, 2025

section .data
    ; Messages for user interaction
    welcome_msg db 'Simple Assembly Calculator', 0xA, 'Operations: +, -, *, /', 0xA, 0
    welcome_len equ $ - welcome_msg
    
    prompt1 db 'Enter first number: ', 0
    prompt1_len equ $ - prompt1
    
    prompt2 db 'Enter second number: ', 0
    prompt2_len equ $ - prompt2
    
    op_prompt db 'Enter operation (+, -, *, /): ', 0
    op_prompt_len equ $ - op_prompt
    
    result_msg db 'Result: ', 0
    result_len equ $ - result_msg
    
    error_msg db 'Error: Division by zero or invalid operation!', 0xA, 0
    error_len equ $ - error_msg
    
    newline db 0xA, 0
    newline_len equ $ - newline
    
    continue_msg db 'Continue? (y/n): ', 0
    continue_len equ $ - continue_msg
    
    goodbye_msg db 'Goodbye!', 0xA, 0
    goodbye_len equ $ - goodbye_msg

section .bss
    num1 resq 1        ; First number
    num2 resq 1        ; Second number
    result resq 1      ; Result of operation
    buffer resb 64     ; Input buffer
    output resb 64     ; Output buffer
    operation resb 1   ; Operation character

section .text
    global _start

_start:
    ; Display welcome message
    mov rax, 1         ; sys_write
    mov rdi, 1         ; stdout
    mov rsi, welcome_msg
    mov rdx, welcome_len
    syscall

main_loop:
    ; Get first number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall
    
    call read_number
    mov [num1], rax
    
    ; Get operation
    mov rax, 1
    mov rdi, 1
    mov rsi, op_prompt
    mov rdx, op_prompt_len
    syscall
    
    call read_operation
    mov [operation], al
    
    ; Get second number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall
    
    call read_number
    mov [num2], rax
    
    ; Perform calculation
    call calculate
    
    ; Display result
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_len
    syscall
    
    mov rax, [result]
    call print_number
    
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    ; Ask to continue
    mov rax, 1
    mov rdi, 1
    mov rsi, continue_msg
    mov rdx, continue_len
    syscall
    
    ; Read continue response
    mov rax, 0         ; sys_read
    mov rdi, 0         ; stdin
    mov rsi, buffer
    mov rdx, 2
    syscall
    
    cmp byte [buffer], 'y'
    je main_loop
    cmp byte [buffer], 'Y'
    je main_loop
    
    ; Exit program
    mov rax, 1
    mov rdi, 1
    mov rsi, goodbye_msg
    mov rdx, goodbye_len
    syscall
    
    mov rax, 60        ; sys_exit
    mov rdi, 0         ; exit status
    syscall

; Function to read a number from input
read_number:
    push rbp
    mov rbp, rsp
    
    ; Read input
    mov rax, 0         ; sys_read
    mov rdi, 0         ; stdin
    mov rsi, buffer
    mov rdx, 64
    syscall
    
    ; Convert string to integer
    mov rsi, buffer
    xor rax, rax       ; result = 0
    xor rcx, rcx       ; sign = 0
    
    ; Check for negative sign
    cmp byte [rsi], '-'
    jne convert_loop
    mov rcx, 1         ; sign = 1 (negative)
    inc rsi            ; skip '-'
    
convert_loop:
    mov dl, [rsi]      ; get character
    cmp dl, 0xA        ; check for newline
    je convert_done
    cmp dl, 0          ; check for null terminator
    je convert_done
    cmp dl, '0'        ; check if valid digit
    jl convert_done
    cmp dl, '9'
    jg convert_done
    
    sub dl, '0'        ; convert to digit
    imul rax, 10       ; multiply result by 10
    add rax, rdx       ; add digit
    inc rsi            ; next character
    jmp convert_loop
    
convert_done:
    cmp rcx, 1         ; check if negative
    jne read_number_return
    neg rax            ; make negative
    
read_number_return:
    pop rbp
    ret

; Function to read operation character
read_operation:
    push rbp
    mov rbp, rsp
    
    mov rax, 0         ; sys_read
    mov rdi, 0         ; stdin
    mov rsi, buffer
    mov rdx, 2
    syscall
    
    mov al, [buffer]   ; get operation character
    
    pop rbp
    ret

; Function to perform calculation
calculate:
    push rbp
    mov rbp, rsp
    
    mov rax, [num1]
    mov rbx, [num2]
    mov cl, [operation]
    
    cmp cl, '+'
    je do_addition
    cmp cl, '-'
    je do_subtraction
    cmp cl, '*'
    je do_multiplication
    cmp cl, '/'
    je do_division
    
    ; Invalid operation
    jmp calc_error
    
do_addition:
    add rax, rbx
    jmp calc_done
    
do_subtraction:
    sub rax, rbx
    jmp calc_done
    
do_multiplication:
    imul rax, rbx
    jmp calc_done
    
do_division:
    cmp rbx, 0         ; check for division by zero
    je calc_error
    
    cqo                ; sign extend rax to rdx:rax
    idiv rbx           ; divide rdx:rax by rbx
    jmp calc_done
    
calc_error:
    ; Display error message
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    ; Exit program
    mov rax, 60
    mov rdi, 1
    syscall
    
calc_done:
    mov [result], rax
    
    pop rbp
    ret

; Function to print a number
print_number:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    
    mov rbx, rax       ; number to print
    mov rcx, 0         ; digit counter
    
    ; Handle negative numbers
    cmp rbx, 0
    jge print_positive
    
    ; Print negative sign
    push rbx
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov byte [output], '-'
    mov rdx, 1
    syscall
    pop rbx
    
    neg rbx            ; make positive
    
print_positive:
    ; Handle zero case
    cmp rbx, 0
    jne print_digits
    mov byte [output], '0'
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, 1
    syscall
    jmp print_done
    
print_digits:
    ; Convert number to string (reverse order)
    mov rsi, output
    add rsi, 63        ; point to end of buffer
    mov byte [rsi], 0  ; null terminator
    
print_loop:
    dec rsi
    mov rax, rbx
    mov rdx, 0
    mov rcx, 10
    div rcx            ; divide by 10
    add dl, '0'        ; convert remainder to ASCII
    mov [rsi], dl      ; store digit
    mov rbx, rax       ; quotient becomes new number
    cmp rbx, 0
    jne print_loop
    
    ; Calculate length and print
    mov rax, output
    add rax, 63
    sub rax, rsi       ; length = end - start
    mov rdx, rax
    
    mov rax, 1         ; sys_write
    mov rdi, 1         ; stdout
    syscall
    
print_done:
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret
