.text
.global _start

_start:
    # Initialize counters
    xor %r8, %r8   # Node counter
    xor %r9, %r9   # Leaf counter

    # Start traversal from root
    mov $root, %rax

    # Level 1
    addq $1, %r8
    cmpq $0, (%r10)
    je check_leaf1

level1_loop:
    movq (%r10), %r11
    cmpq $0, %r11
    je check_leaf1
    addq $1, %r8

level2_loop:
    movq (%r11), %r12
    cmpq $0, %rsi
    je check_leaf2
    addq $1, %r8

level3_loop:
    movq (%r12), %r13
    cmpq $0, %rsi
    je check_leaf3
    addq $1, %r8

level4_loop:
    movq (%r13), %r14
    cmpq $0, %rsi
    je check_leaf4
    addq $1, %r8

level5_loop:
    movq (%r14), %r15
    cmpq $0, %r15
    je check_leaf5
    addq $1, %r8

level6:
    addq $1, %r8
    addq $1, %r9
    addq $8, %r15

level5_next:
    addq $8, %r14
    jmp level5_loop

level4_next:
    addq $8, %r13
    jmp level4_loop

level3_next:
    addq $8, %r12
    jmp level3_loop

level2_next:
    addq $8, %r11
    jmp level2_loop

level1_next:
    addq $8, %r10
    jmp level1_loop

check_leaf1:
    addq $1, %r9
    jmp compare

check_leaf2:
    addq $1, %r9
    jmp level1_next

check_leaf3:
    addq $1, %r9
    jmp level2_next 

check_leaf4:
    addq $1, %r9
    jmp level3_next

check_leaf5:
    addq $1, %r9
    jmp level4_next

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

greater_than:
    movq $0, rich_label

done:
    # Exit