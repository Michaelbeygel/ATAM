.text
.global _start

_start:
    # Initialize counters
    xor %r8, %r8   # Node counter
    xor %r9, %r9   # Leaf counter

    # Start traversal from root
    movq $root, %r10

    # Level 1
    addq $1, %r8
    cmpq $0, (%r10)
    jne level1_loop_HW1
    addq $1, %r9
    jmp compare_HW1

level1_loop_HW1:
    movq (%r10), %r11
    cmpq $0, %r11
    je check_leaf1_HW1
    addq $1, %r8

level2_loop_HW1:
    movq (%r11), %r12
    cmpq $0, %r12
    je check_leaf2_HW1
    addq $1, %r8

level3_loop_HW1:
    movq (%r12), %r13
    cmpq $0, %r13
    je check_leaf3_HW1
    addq $1, %r8

level4_loop_HW1:
    movq (%r13), %r14
    cmpq $0, %r14
    je check_leaf4_HW1
    addq $1, %r8

level5_loop_HW1:
    movq (%r14), %r15
    cmpq $0, %r15
    je check_leaf5_HW1
    addq $1, %r8

level6_HW1:
    addq $1, %r8
    addq $1, %r9
    addq $8, %r15

level5_next_HW1:
    addq $8, %r14
    jmp level5_loop_HW1

level4_next_HW1:
    addq $8, %r13
    jmp level4_loop_HW1

level3_next_HW1:
    addq $8, %r12
    jmp level3_loop_HW1

level2_next_HW1:
    addq $8, %r11
    jmp level2_loop_HW1

level1_next_HW1:
    addq $8, %r10
    jmp level1_loop_HW1

check_leaf1_HW1:
    cmpq (root), %r10
    jne compare_HW1
    addq $1, %r9
    jmp compare_HW1

check_leaf2_HW1:
    cmpq (%r10), %r11
    jne level1_next_HW1
    addq $1, %r9
    jmp level1_next_HW1

check_leaf3_HW1:
    cmpq (%r11), %r12
    jne level2_next_HW1
    addq $1, %r9
    jmp level2_next_HW1 

check_leaf4_HW1:
    cmpq (%r12), %r13
    jne level3_next_HW1
    addq $1, %r9
    jmp level3_next_HW1

check_leaf5_HW1:
    cmpq (%r13), %r14
    jne level4_next_HW1
    addq $1, %r9
    jmp level4_next_HW1

compare_HW1:
    movq %r9, %rax
    movq $3, %rbx
    imulq %rbx
    cmpq %rax, %r8
    jg greater_than_HW1
    movq $1, rich
    jmp done_HW1

greater_than_HW1:
    movq $0, rich

done_HW1:
