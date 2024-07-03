.data
root: .quad a, b, 0
a: .quad c, 0
b: .quad d, 0
c: .quad 0
d: .quad 0

.text
.global _start

_start:
    # Initialize counters
    movq $0, %r8   # Node counter
    movq $0, %r9   # Leaf counter

    # Traverse the tree using nested loops
    movq $root, %rdi
    jmp traverse

    # Store results
    movq %r8, %rax   # Store node counter in register
    movq %r9, %rbx   # Store leaf counter in register

    # Exit the program
    movq $60, %rax   # syscall: exit
    xor %rdi, %rdi   # status: 0
    syscall

traverse:
    # Loop 1
    cmpq $0, (%rdi)
    je done
    addq $1, %r8
    movq (%rdi), %rsi

    # Loop 2
    cmpq $0, (%rsi)
    je loop1_end
    addq $1, %r8
    movq (%rsi), %rdx

    # Loop 3
    cmpq $0, (%rdx)
    je loop2_end
    addq $1, %r8
    movq (%rdx), %rcx

    # Loop 4
    cmpq $0, (%rcx)
    je loop3_end
    addq $1, %r8
    movq (%rcx), %rbx

    # Loop 5
    cmpq $0, (%rbx)
    je loop4_end
    addq $1, %r8
    movq (%rbx), %r10

    # Loop 6
    cmpq $0, (%r10)
    je loop5_end
    addq $1, %r8
    jmp count_leaves

loop5_end:
    cmpq $0, 8(%rbx)
    jne count_leaves
    addq $1, %r9
    jmp loop4_end

loop4_end:
    cmpq $0, 8(%rcx)
    jne loop5
    addq $1, %r9
    jmp loop3_end

loop3_end:
    cmpq $0, 8(%rdx)
    jne loop4
    addq $1, %r9
    jmp loop2_end

loop2_end:
    cmpq $0, 8(%rsi)
    jne loop3
    addq $1, %r9
    jmp loop1_end

loop1_end:
    cmpq $0, 8(%rdi)
    jne loop2
    addq $1, %r9

done:
    ret

count_leaves:
    # Count leaves in loop 6
    cmpq $0, 8(%r10)
    jne loop5_end
    addq $1, %r9
    jmp loop5_end
