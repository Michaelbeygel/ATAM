.section .text
.global _start

_start:
    leaq series(%rip), %rdi
    movq $0, %rsi # index
    movq size(%rip), %rbx # size
    cmpq $3, %rbx
    jl success
    movslq (%rdi, %rsi, 4), %r13 # a0
    incq %rsi
    movslq (%rdi, %rsi, 4), %r14 # a1
    incq %rsi
    movslq (%rdi, %rsi, 4), %r15 # a2
    

check_diffs_diff_series:
    movq %r14, %rcx # move to calculate base diff
    imul $2, %rcx # 2a_1
    movq %r13, %r8 # a_0
    subq %rcx, %r8 # a_0 - 2a_1
    addq %r15, %r8 # a_0 - 2a_1 + a_2 as base diff
    movq %r13, %r10 # a_i-2
    movq %r14, %r11 # a_i-1
    movq %r15, %r12 # a_i

check_diffs_diff_series_loop:
    cmpq %rsi, %rbx
    je success
    movslq (%rdi, %rsi, 4), %r12
    movq %r11, %r9 # move for multiplication
    imul $2, %r9 # 2a_i-1
    subq %r9, %r10 # a_i-2 - 2a_i-1
    addq %r12, %r10 # a_i-2 - 2a_i-1 + a_i
    cmpq %r10, %r8 # compare diffs
    jne check_diffs_geo_series
    incq %rsi
    movq %r11, %r10
    movq %r12, %r11
    jmp check_diffs_diff_series_loop

check_diffs_geo_series:
    movq %r13, %r10 # a_i-2
    movq %r14, %r11 # a_i-1
    movq %r15, %r12 # a_i
    movq $2, %rsi # index

check_diffs_geo_series_loop:
    cmpq %rsi, %rbx
    je success
    movslq (%rdi, %rsi, 4), %r12
    movq %r11, %r8 # a_i-1
    subq %r10, %r8 # a_i-1 - a_i-2
    imul %r15, %r8 # a_2(a_i-1 - a_i-2)
    movq %r12, %rcx # a_i
    subq %r10, %rcx # a_i - a_i-2
    imul %r14, %rcx # a_1(a_i - a_i-2)
    movq %rcx, %r10
    movq %r11, %rcx # a_i-1
    subq %r12, %rcx # a_i-1 - a_i
    imul %r13, %rcx # a_0(a_i-1 - a_i)
    addq %rcx, %r10 # a_0(a_i-1 - a_i) + a_1(a_i - a_i-2)
    cmpq %r10, %r8 # compare diffs
    jne check_ratios_diff_series
    incq %rsi
    movq %r11, %r10
    movq %r12, %r11
    jmp check_diffs_geo_series_loop


check_ratios_diff_series:
    movq %r15, %r9 # a_2
    imul %r13, %r9 # a_0 * a_2
    movq %r14, %rax # a_1
    imul %rax, %rax # a_1 ^ 2
    subq %rax, %r9 # a_0 * a_2 - a_1 ^ 2
    movq %r14, %rax # a_1
    imul %r13, %rax # a_0 * a_1
    movq %r13, %r10 # a_i-2
    movq %r14, %r11 # a_i-1
    movq %r15, %r12 # a_i
    movq $2, %rsi # index

check_ratios_diff_series_loop:
    cmpq %rsi, %rbx
    je success
    movslq (%rdi, %rsi, 4), %r12
    movq %r10, %r8 # a_i-2 
    imul %r12, %r8 # a_i * a_i-2
    movq %r11, %rcx # a_i-1
    imul %rcx, %rcx # a_i-1 ^ 2
    subq %rcx, %r8 # a_i * a_i-2 - a_i-1 ^ 2
    imul %rax, %r8 # a_o*a_1 * (a_i * a_i-2 - a_i-1 ^ 2)
    imul %r11, %r10 # a_i-1 * a_i-2
    imul %r9, %r10 # a_i-1 * a_i-2 (a_0 * a_2 - a_1 ^ 2)
    cmpq %r10, %r8 # compare diffs
    jne check_ratios_geo_series
    incq %rsi
    movq %r11, %r10
    movq %r12, %r11
    jmp check_ratios_diff_series_loop

check_ratios_geo_series:
    movq %r14, %r9 # a_1
    imul %r9, %r9 # a_1 ^ 2
    movq %r15, %rax # a_2
    imul %r13, %rax # a_2 * a_0
    movq %r13, %r10 # a_i-2
    movq %r14, %r11 # a_i-1
    movq %r15, %r12 # a_i
    movq $2, %rsi # index

check_ratios_geo_series_loop:
    cmpq %rsi, %rbx
    je success
    movslq (%rdi, %rsi, 4), %r12
    imul %r12, %r10 # a_i * a_i-2
    imul %r9, %r10 # a_1 ^ 2 * a_i * a_i-2
    movq %r11, %r8 # a_i-1
    imul %r8, %r8 # a_i-1 ^ 2
    imul %rax, %r8 # a_2 * a_0 * a_i-1 ^ 2
    cmpq %r10, %r8 # compare ratios
    jne done
    incq %rsi
    movq %r11, %r10
    movq %r12, %r11
    jmp check_ratios_geo_series_loop

success:
    movq $1, seconddegree

done:
