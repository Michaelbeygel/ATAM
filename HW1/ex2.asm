.global _start

.section .text
_start:

    # Load the size into RSI
    movq size(%rip), %rsi

    # Initialize pointers and load values
    leaq data(%rip), %rdi   # Pointer to data
    xor %r8, %r8            # Initialize counter
    movq %rsi, %rcx         # Size of data in bytes
    decq %rcx               # Ignore the terminator null
    movq %rcx, %rbx         # Save original size
    movb $4, type(%rip)

    # Simple string test
simple_string_check_HW1:
    movb (%rdi), %al       # Load byte from data
    testb %al, %al
    je not_scientific_string_HW1 # If byte is null, then it is not a string (scientific or simple)
    cmpb $',', %al
    je continue_simple_string_HW1 # If byte is comma, continue looping
    cmpb $'.', %al
    je continue_simple_string_HW1 # If byte is dot, continue looping
    cmpb $'?', %al
    je continue_simple_string_HW1 # If byte is question mark, continue looping
    cmpb $'!', %al
    je continue_simple_string_HW1 # If byte is exclamation mark, continue looping
    cmpb $' ', %al
    je continue_simple_string_HW1 # If byte is space, continue looping    
    jmp check_numbers_HW1

check_numbers_HW1:
    cmpb $'0', %al
    jl check_lowercase_HW1
    cmpb $'9', %al
    jg check_lowercase_HW1 # If byte is under 0, continue looping
    jmp continue_simple_string_HW1

check_lowercase_HW1:
    cmpb $'a', %al
    jl check_uppercase_HW1
    cmpb $'z', %al
    jg check_uppercase_HW1
    jmp continue_simple_string_HW1

check_uppercase_HW1:
    cmpb $'A', %al
    jl not_simple_string_HW1
    cmpb $'Z', %al
    jg not_simple_string_HW1
    jmp continue_simple_string_HW1

continue_simple_string_HW1:
    incq %rdi
    incq %r8
    cmpq %r8, %rbx         # Compare current pointer with original size
    je set_type_simple_HW1
    jmp simple_string_check_HW1 # Otherwise, continue looping

not_simple_string_HW1:
    # Scientific string test
    leaq data(%rip), %rdi
    xor %r8, %r8            # Initialize counter

scientific_string_check_HW1:
    movb (%rdi), %al       # Load byte from data
    testb %al, %al
    je not_scientific_string_HW1 # If byte is null, then it is not a scientific string
    cmpb $32, %al
    jl not_scientific_string_HW1
    cmpb $126, %al
    jg not_scientific_string_HW1
    incq %rdi
    incq %r8
    cmpq %r8, %rbx         # Compare current pointer with original size
    je set_type_scientific_HW1
    jmp scientific_string_check_HW1 # Otherwise, continue looping

not_scientific_string_HW1:
    # Check divisibility by 8, and non-nullity test of all 8 consecutive bytes
    leaq data(%rip), %rdi
    incq %rbx
    movq %rbx, %rcx
    andq $7, %rcx
    testq %rcx, %rcx
    jnz done_HW1    # If not divisible by 8, set type to 4 (default)
    movq %rbx, %rcx
    xor %r10, %r10
    movabsq $0x3030303030303030, %r10

check_blocks_HW1:
    movq (%rdi), %rax       # Load 8 bytes from data
    cmpq %r10, %rax 
    je done_HW1  # If block is null, exit
    addq $8, %rdi
    subq $8, %rcx
    cmpq $7, %rcx           # Compare remaining bytes with 7 (next block size - 1)
    jg check_blocks_HW1         # If greater, continue checking next block
    jmp set_type_divisible_HW1          # Otherwise, set type to 3 (divisible by 8)

set_type_simple_HW1:
    movb (%rdi), %al       # Load byte from data
    testb %al, %al
    jne not_scientific_string_HW1
    movb $1, type(%rip)     # Set type to 1 (simple string)
    jmp done_HW1

set_type_scientific_HW1:
    movb (%rdi), %al       # Load byte from data
    testb %al, %al
    jne not_scientific_string_HW1
    movb $2, type(%rip)     # Set type to 2 (scientific string)
    jmp done_HW1

set_type_divisible_HW1:
    movb (%rdi), %al       # Load byte from data
    movb $3, type(%rip)     # Set type to 3 (divisible by 8)
    jmp done_HW1

done_HW1:
    # Exit the program
