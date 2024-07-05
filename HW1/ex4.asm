.global _start

.section .text
_start:

    xor %r10, %r10   # counter for number of "good nodes"

    mov $0, %r12   # counter for number of nodes to check on


    lea nodes(%rip), %rbp    # Load address of nodes into rbp
    mov (%rbp), %rsi         # Load first node pointer into rsi

    

    mov %rsi, %rdi # store the current node

    # travel back to find the first node
    # travel back to find the first node
find_first_node:
    movq (%rsi), %rax        # Load prev pointer (offset 0 bytes) into rax
    testq %rax, %rax         # Check if prev pointer is NULL
    jz found_first_node      # If NULL, found the first node
    movq %rax, %rsi          # Move to previous node (rsi = prev)
    jmp find_first_node      # Continue loop

found_first_node:
    # Store address of the first node in r8
    movq %rsi, %r8
    mov %rdi, %rsi # restore the current node to rsi

find_last_node:
    movq 12(%rsi), %rbx        # Load next pointer (offset 0 bytes) into rbx
    testq %rbx, %rbx         # Check if nezt pointer is NULL
    jz found_last_node      # If NULL, found the last node
    movq %rbx, %rsi          # Move to next node (rsi = prev)

    jmp find_last_node      # Continue loop

found_last_node:
    # Store address of the last node in r9
    movq %rsi, %r9
 
    mov %rdi, %rsi # restore the current node to rsi


    # status before loop on all the nodes in the list:
    # r8 = first node of the list
    # r9 = last node of the list
sort_check_for_all_nodes: # loop for each of the 3 nodes
    cmp $3, %r12 # if we check all 3 nodes
    jge Done
    mov (%rbp, %r12, 8), %rsi # rsi = the next node in the given list
    inc %r12


check_left_side:
    xor %r11, %r11 # check if left side is checked
    mov %r8, %rax 
    mov (%rsi), %rbx
    jmp check_sorted

check_right_side:
    inc %r11
    mov %rdi, %rsi # restore the current node into rsi

    

check_sorted:
    mov $1, %r13 # increasing flag = true
    mov $1, %r14 # decreasing flag = true

// check if list is sorted, asume the start node = rax, end node = rbx
check_sorted_loop:
    test %rax, %rax 
    je not_sorted  # check if start is null

    test %rbx, %rbx 
    je not_sorted  # check if end is null

    mov %rax, %rsi
    mov 12(%rsi), %r15
    cmp %rbx, 12(%rsi)             # Compare current->next (12 bytes offset) with end
    je check_sorted_loop_end       # If current->next == end, jump to loop_end

    mov 12(%rsi), %rdx #   rdx = current->next
    mov 8(%rdx) ,%rcx  #   rcx = current->next->data

    
    cmp  %rcx ,8(%rsi) # check if current->next->data < current->data 
    jg set_not_increasing

continue_loop1:
    cmp  %rcx ,8(%rsi) # check if current->next->data > current->data
    jl set_not_decreasing

continue_loop2:
    mov 12(%rsi), %rsi     # Move to the next node (current = current->next)
    jmp check_sorted_loop         # Repeat the loop    

set_not_increasing: 
    mov $0, %r13
    jmp continue_loop1

set_not_decreasing:
    mov $0, %r14
    jmp continue_loop2

check_sorted_loop_end:
    cmp $1 ,%r13 # check if increasing seria
    je is_sorted 

    cmp $1 ,%r14  # check if decreasing seria
    je is_sorted

    jmp not_sorted

is_sorted:
    cmp $0, %r11
    je check_right_side
    jmp set_sort_count

set_sort_count:
    inc %r10 # inc coount if the left and the right side is sorted

not_sorted:
    mov %rdi, %rsi # restore the current node into rsi

    jmp sort_check_for_all_nodes

Done:
    mov %r10, result
