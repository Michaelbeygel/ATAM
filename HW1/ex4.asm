.global _start

.section .text
_start:

    xor %r10, %r10   # counter for number of "good nodes"

    xor %r12, %r12   # counter for number of nodes to check on


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
all_nodes_loop: # loop for each of the 3 nodes
    cmp $3, %r12 # if we check all 3 nodes
    je set_result
    mov (%rbp, %r12, 8), %rsi # rsi = the next node in the given list
    inc %r12
    mov %rsi, %rdi # store the current node


check_left_side:
    xor %r11, %r11 # check if left side is checked
    mov %r8, %rax 
    mov (%rsi), %rbx
    jmp check_sorted  



check_right_side:
    inc %r11
    mov %rdi, %rsi # restore the current node into rsi
    mov 12(%rsi), %rax 
    mov %r9, %rbx
    jmp check_sorted  

    

check_sorted:
    mov $1, %r13 # increasing flag = true
    mov $1, %r14 # decreasing flag = true

    test %rax, %rax 
    je is_sorted  # check if start is null

    test %rbx, %rbx 
    je is_sorted  # check if end is null

    mov %rax, %rsi

// check if list is sorted, asume the start node = rax, end node = rbx
check_sorted_loop:

    cmp %rbx, %rsi            # Compare current->next (12 bytes offset) with end
    je check_sorted_loop_end       # If current->next == end, jump to loop_end

    mov 12(%rsi), %rdx #   rdx = current->next  

    movsxd 8(%rdx), %rcx  #   rcx = current->next->data

    movsxd 8(%rsi), %rdx      # rax = (signed) current->data
    
    

    
    cmp  %rcx ,%rdx # check if current->next->data < current->data 
    jg set_not_increasing

continue_sorted_loop1:
    cmp  %rcx ,%rdx # check if current->next->data > current->data
    jl set_not_decreasing

continue_sorted_loop2:
    mov 12(%rsi), %rsi     # Move to the next node (current = current->next)
    jmp check_sorted_loop         # Repeat the loop    

set_not_increasing: 
    mov $0, %r13
    jmp continue_sorted_loop1

set_not_decreasing:
    mov $0, %r14
    jmp continue_sorted_loop2

check_sorted_loop_end:
    cmp $1 ,%r13 # check if increasing seria
    je is_sorted 

    cmp $1 ,%r14  # check if decreasing seria
    je is_sorted

    jmp next_node

is_sorted:
    cmp $0, %r11
    je check_right_side
    jmp set_sort_count
set_sort_count:
    inc %r10        # inc coount if the left and the right side is sorted

next_node:
    jmp all_nodes_loop

set_result:
    movq %r10, result
    jmp done

done: 
