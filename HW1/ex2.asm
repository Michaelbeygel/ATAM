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
    je set_type_simple     # If byte is null, set type to 1 (simple string)
    cmpb $' ', %al
    jl not_simple_string
    cmpb $'~', %al
    jg not_simple_string
    incq %rdi
    cmpq %rdi, %rbx         # Compare current pointer with original size
    jb check_type           # Jump to check_type if end of data reached
    jmp simple_string_check # Otherwise, continue looping

not_simple_string:
    # Scientific string test
    leaq data(%rip), %rdi
scientific_string_check:
    movb (%rdi), %al        # Load byte from data
    testb %al, %al
    je set_type_scientific  # If byte is null, set type to 2 (scientific string)
    cmpb $32, %al
    jl not_scientific_string
    cmpb $126, %al
    jg not_scientific_string
    incq %rdi
    cmpq %rdi, %rbx         # Compare current pointer with original size
    jb check_type           # Jump to check_type if end of data reached
    jmp scientific_string_check # Otherwise, continue looping

not_scientific_string:
    # Check divisibility by 8, and non-nullity test of all 8 consecutive bytes
    leaq data(%rip), %rdi
    movq %rbx, %rcx
    testq %rbx, $7
    jnz set_type_default    # If not divisible by 8, set type to 4 (default)
check_blocks:
    movq (%rdi), %rax       # Load 8 bytes from data
    testq %rax, %rax
    jz set_type_divisible  # If block is null, set type to 3 (divisible by 8)
    addq $8, %rdi
    subq $8, %rcx
    cmpq $7, %rcx           # Compare remaining bytes with 7 (next block size - 1)
    jg check_blocks         # If greater, continue checking next block
    jmp check_type          # Otherwise, jump to check_type

set_type_simple:
    movb $1, type(%rip)     # Set type to 1 (simple string)
    jmp done

set_type_scientific:
    movb $2, type(%rip)     # Set type to 2 (scientific string)
    jmp done

set_type_divisible:
    movb $3, type(%rip)     # Set type to 3 (divisible by 8)
    jmp done

set_type_default:
    movb $4, type(%rip)     # Set type to 4 (default)
    jmp done

check_type:
    # If none matched, set default type 4
    movb $4, type(%rip)

done:
    # Exit the program

