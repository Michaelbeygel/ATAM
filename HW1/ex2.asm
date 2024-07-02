.global _start

.section .text
_start:

    # Load the size into RSI
    movq size(%rip), %rsi

    # Initialize pointers and load values
    leaq data(%rip), %rdi   # Pointer to data
    movq %rsi, %rcx         # Size of data in bytes
    decq %rcx               # Ignore the terminator null
    movq %rcx, %rbx         # Save original size
    movb $4, type(%rip)

    # Simple string test
simple_string_check:
    movb (%rdi), %al       # Load byte from data
    testb %al, %al
    je not_scientific_string # If byte is null, then it is not a string (scientific or simple)
    cmpb $' ', %al
    jl not_simple_string
    cmpb $'~', %al
    jg not_simple_string
    incq %rdi
    cmpq %rdi, %rbx         # Compare current pointer with original size
    je set_type_simple
    jmp simple_string_check # Otherwise, continue looping

not_simple_string:
    # Scientific string test
    leaq data(%rip), %rdi
scientific_string_check:
    movb (%rdi), %al       # Load byte from data
    testb %al, %al
    je not_scientific_string # If byte is null, then it is not a scientific string
    cmpb $32, %al
    jl not_scientific_string
    cmpb $126, %al
    jg not_scientific_string
    incq %rdi
    cmpq %rdi, %rbx         # Compare current pointer with original size
    je set_type_scientific
    jmp scientific_string_check # Otherwise, continue looping

not_scientific_string:
    # Check divisibility by 8, and non-nullity test of all 8 consecutive bytes
    leaq data(%rip), %rdi
    movq %rbx, %rcx
    testq %rbx, $7
    jnz done    # If not divisible by 8, set type to 4 (default)
check_blocks:
    movq (%rdi), %rax       # Load 8 bytes from data
    testq %rax, %rax
    je done  # If block is null, exit
    addq $8, %rdi
    subq $8, %rcx
    cmpq $7, %rcx           # Compare remaining bytes with 7 (next block size - 1)
    jg check_blocks         # If greater, continue checking next block
    jmp set_type_divisible          # Otherwise, set type to 3 (divisible by 8)

set_type_simple:
    movb $1, type(%rip)     # Set type to 1 (simple string)
    jmp done

set_type_scientific:
    movb $2, type(%rip)     # Set type to 2 (scientific string)
    jmp done

set_type_divisible:
    movb $3, type(%rip)     # Set type to 3 (divisible by 8)
    jmp done

done:
    # Exit the program

