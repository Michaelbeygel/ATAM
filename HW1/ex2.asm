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

    # Simple string test
simple_string_check:
    movb (%rdi), %al        # Load byte from data
    testb %al, %al
    je check_type
    cmpb $' ', %al
    jl not_simple_string
    cmpb $'~', %al
    jg not_simple_string
    incq %rdi
    loop simple_string_check
    movb $1, type(%rip)
    jmp done

not_simple_string:
    # Scientific string test
    leaq data(%rip), %rdi
scientific_string_check:
    movb (%rdi), %al        # Load byte from data
    testb %al, %al
    je check_type
    cmpb $' ', %al
    jl not_scientific_string
    cmpb $'~', %al
    jg not_scientific_string
    incq %rdi
    loop scientific_string_check
    movb $2, type(%rip)
    jmp done

not_scientific_string:
    # Check divisibility by 8, and non-nullity test of all 8 consecutive bytes
    leaq data(%rip), %rdi
    movq %rbx, %rcx
    testq %rbx, $7
    jnz not_divisible_by_8
check_blocks:
    movq (%rdi), %rax       # Load 8 bytes from data
    testq %rax, %rax
    jz not_divisible_by_8
    addq $8, %rdi
    subq $8, %rcx
    jnz check_blocks
    movb $3, type(%rip)
    jmp done

not_divisible_by_8:

    # Else
    movb $4, type(%rip)
done:
    # Exit the program