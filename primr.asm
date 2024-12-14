section .data
    limit dq 100                  ; The limit for finding primes
    sieve resb 101                ; Boolean array (size limit + 1)
    output db "Prime: %d", 10, 0  ; Format for output

section .bss
    i resq 1                      ; Iterator variable
    j resq 1                      ; Iterator for marking multiples

section .text
    extern printf
    global main

main:
    ; Initialize sieve array to true (1)
    lea rdi, [sieve]              ; Load address of sieve array
    mov rcx, 101                  ; Number of bytes to initialize
    xor rax, rax                  ; Clear RAX (value 0)
    mov rsi, 1                    ; Value to set (true)
    rep stosb                     ; Fill sieve with 1s (true)

    ; Mark 0 and 1 as non-prime
    mov byte [sieve + 0], 0       ; sieve[0] = false
    mov byte [sieve + 1], 0       ; sieve[1] = false

    ; Outer loop: for i = 2 to sqrt(limit)
    xor rax, rax                  ; Clear RAX
    mov rax, 2                    ; i = 2
.loop_outer:
    cmp rax, 10                   ; If i > sqrt(100), exit loop (sqrt(100) ~ 10)
    jg .done_outer

    ; Check if sieve[i] is true
    movzx rbx, byte [sieve + rax] ; Load sieve[i] into RBX
    test rbx, rbx                 ; Check if sieve[i] == 0
    jz .next_outer                ; Skip if not prime

    ; Inner loop: for j = i*i to limit, step by i
    mov rcx, rax                  ; j = i * i
    imul rcx, rcx                 ; rcx = i * i
.loop_inner:
    cmp rcx, [limit]              ; If j > limit, exit loop
    ja .done_inner

    ; Mark sieve[j] as false
    mov byte [sieve + rcx], 0     ; sieve[j] = false
    add rcx, rax                  ; j += i
    jmp .loop_inner
.done_inner:

    ; Increment i
.next_outer:
    inc rax                       ; i++
    jmp .loop_outer
.done_outer:

    ; Print primes
    xor rax, rax                  ; Clear RAX
    mov rax, 2                    ; i = 2
.print_loop:
    cmp rax, [limit]              ; If i > limit, exit
    ja .done_print

    ; Check if sieve[i] is true
    movzx rbx, byte [sieve + rax] ; Load sieve[i]
    test rbx, rbx                 ; Check if sieve[i] == 0
    jz .next_print                ; Skip if not prime

    ; Print the prime
    mov rdi, output               ; Address of output format
    mov rsi, rax                  ; Prime number to print
    xor rax, rax                  ; Clear RAX for variadic functions
    call printf                   ; Print the prime

.next_print:
    inc rax                       ; i++
    jmp .print_loop
.done_print:

    ; Exit program
    xor rax, rax
    ret
