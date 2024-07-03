.text
.global _start

_start:
    # Initialize counters
    xor %r8, %r8   # Node counter
    xor %r9, %r9   # Leaf counter

    # Start traversal from root
    mov $root, %rdi

    # Level 1
    cmpq $0, (%rdi)
    je check_leaf1
    addq $1, %r8

level1_loop:
    movq (%rdi), %rsi
    cmpq $0, %rsi
    je level1_next
    addq $1, %r8

    # Level 2
    movq %rsi, %rdi
    cmpq $0, (%rdi)
    je check_leaf2
    addq $1, %r8

level2_loop:
    movq (%rdi), %rsi
    cmpq $0, %rsi
    je level2_next
    addq $1, %r8

    # Level 3
    movq %rsi, %rdi
    cmpq $0, (%rdi)
    je check_leaf3
    addq $1, %r8

level3_loop:
    movq (%rdi), %rsi
    cmpq $0, %rsi
    je level3_next
    addq $1, %r8

    # Level 4
    movq %rsi, %rdi
    cmpq $0, (%rdi)
    je check_leaf4
    addq $1, %r8

level4_loop:
    movq (%rdi), %rsi
    cmpq $0, %rsi
    je level4_next
    addq $1, %r8

    # Level 5
    movq %rsi, %rdi
    cmpq $0, (%rdi)
    je check_leaf5
    addq $1, %r8

level5_loop:
    movq (%rdi), %rsi
    cmpq $0, %rsi
    je level5_next
    addq $1, %r8

    # Level 6
    movq %rsi, %rdi
    cmpq $0, (%rdi)
    je check_leaf6
    addq $1, %r8

level6_loop:
    movq (%rdi), %rsi
    cmpq $0, %rsi
    je level6_next
    addq $1, %r8

    # No further levels, check for leaf
    jmp check_leaf6

level6_next:
    addq $8, %rdi
    jmp level6_loop

check_leaf6:
    addq $1, %r9

level5_next:
    addq $8, %rdi
    jmp level5_loop

check_leaf5:
    addq $1, %r9

level4_next:
    addq $8, %rdi
    jmp level4_loop

check_leaf4:
    addq $1, %r9

level3_next:
    addq $8, %rdi
    jmp level3_loop

check_leaf3:
    addq $1, %r9

level2_next:
    addq $8, %rdi
    jmp level2_loop

check_leaf2:
    addq $1, %r9

level1_next:
    addq $8, %rdi
    jmp level1_loop

check_leaf1:
    addq $1, %r9

compare:

    movq %r8, %rax
    movq $3, %rbx
    cqo
    idivq %rbx
    movq %rax, %r8

    cmpq %r8, %r9
    jg greater_than
    movq $1, rich_label
    jmp done

greater_than_or:
    movq $0, rich_label

done:
    # Exit