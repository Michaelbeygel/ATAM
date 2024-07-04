.global _start

.section .text
_start:    

check_aritmetic_of_aritmetics:
    xor %eax, %eax # first_diff
    xor %ebx, %ebx # diffs_diff
    xor %ecx, %ecx # ongoing_diff
    xor %edx, %edx # diffs_diff comparator
    xor %ebp, %ebp # index
    movl (size), %esi # size
    movl series(, %ebp, 4), %eax
    movl 4+series(, %ebp, 4), %ebx
    subl %ebx, %eax
    subl 8+series(, %ebp, 4), %ebx
    subl %eax, %ebx

aritmetic_of_aritmetics_loop:
    cmpl %esi, %ebp
    je success
    movl 4+series(, %ebp, 4), %ecx
    movl %eax, %edx
    subl %ecx, %edx
    cmpl %edx, %ebx
    jne check_geometric_of_geometrics
    addl $1, %ebp
    jmp aritmetic_of_aritmetics_loop

check_geometric_of_geometrics:
    xor %eax, %eax # first_ratio
    xor %ebx, %ebx # ratios_ratio
    xor %ecx, %ecx # ongoing_ratio
    xor %edx, %edx # ratios_diff comparator
    xor %ebp, %ebp # index
    movl (size), %esi # size
    movl series(, %ebp, 4), %eax
    movl 4+series(, %ebp, 4), %ebx
    divl %ebx
    movl 8+series(, %ebp, 4), %ebx
    divl %ebx

geometric_of_geometrics_loop:
    cmpl %esi, %ebp
    je success
    movl 4+series(, %ebp, 4), %ecx
    movl %eax, %edx
    divl %edx
    cmpl %edx, %ebx
    jne failure
    addl $1, %ebp
    jmp geometric_of_geometrics_loop

check_aritmetic_of_geometrics:
    xor %eax, %eax # first_diff
    xor %ebx, %ebx # diffs_ratio
    xor %ecx, %ecx # ongoing_diff
    xor %edx, %edx # diffs_diff comparator
    xor %ebp, %ebp # index
    movl (size), %esi # size
    movl series(, %ebp, 4), %eax
    movl 4+series(, %ebp, 4), %ebx
    subl %ebx, %eax
    divl %ebx
    subl %eax, %ebx

aritmetic_of_geometrics_loop:
    cmpl %esi, %ebp
    je success
    movl 4+series(, %ebp, 4), %ecx
    movl %eax, %edx
    subl %ecx, %edx
    divl %ebx
    cmpl %edx, %ebx
    jne check_geometric_of_aritmetics
    addl $1, %ebp
    jmp aritmetic_of_geometrics_loop

check_geometric_of_aritmetics:
    xor %eax, %eax # first_ratio
    xor %ebx, %ebx # ratios_ratio
    xor %ecx, %ecx # ongoing_ratio
    xor %edx, %edx # ratios_diff comparator
    xor %ebp, %ebp # index
    movl (size), %esi # size
    movl series(, %ebp, 4), %eax
    movl 4+series(, %ebp, 4), %ebx
    divl %ebx
    subl 8+series(, %ebp, 4), %ebx
    divl %ebx

geometric_of_aritmetics_loop:
    cmpl %esi, %ebp
    je success
    movl 4+series(, %ebp, 4), %ecx
    movl %eax, %edx
    divl %edx
    subl %edx, %ebx
    cmpl %edx, %ebx
    jne failure
    addl $1, %ebp
    jmp geometric_of_aritmetics_loop

success:
    movl $1, (seconddegree)
    jmp exit

failure:
    movl $0, (seconddegree)

exit:
