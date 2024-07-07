.global _start

.section .text
_start:

    xor %r10, %r10   # counter for number of "good nodes"

    xor %r12, %r12   # counter for number of nodes to check on


    leaq nodes(%rip), %rbp    # Load address of nodes into rbp
    movq (%rbp), %rsi         # Load first node pointer into rsi

    

    movq %rsi, %rdi # store the current node

    # travel back to find the first node
    # travel back to find the first node
find_first_node_HW1:
    movq (%rsi), %rax        # Load prev pointer (offset 0 bytes) into rax
    testq %rax, %rax         # Check if prev pointer is NULL
    jz found_first_node_HW1      # If NULL, found the first node
    movq %rax, %rsi          # Move to previous node (rsi = prev)
    jmp find_first_node_HW1      # Continue loop

found_first_node_HW1:
    # Store address of the first node in r8
    movq %rsi, %r8
    movq %rdi, %rsi # restore the current node to rsi

find_last_node_HW1:
    movq 12(%rsi), %rbx        # Load next pointer (offset 0 bytes) into rbx
    testq %rbx, %rbx         # Check if nezt pointer is NULL
    jz found_last_node_HW1      # If NULL, found the last node
    movq %rbx, %rsi          # Move to next node (rsi = prev)

    jmp find_last_node_HW1      # Continue loop

found_last_node_HW1:
    # Store address of the last node in r9
    movq %rsi, %r9
 
    movq %rdi, %rsi # restore the current node to rsi


    # status before loop on all the nodes in the list:
    # r8 = first node of the list
    # r9 = last node of the list
all_nodes_loop_HW1: # loop for each of the 3 nodes
    cmpq $3, %r12 # if we check all 3 nodes
    je set_result_HW1
    movq (%rbp, %r12, 8), %rsi # rsi = the next node in the given list
    incq %r12
    movq %rsi, %rdi # store the current node


check_left_side_HW1:
    xor %r11, %r11 # check if left side is checked
    movq %r8, %rax 
    movq (%rsi), %rbx
    jmp check_sorted_HW1



check_right_side_HW1:
    incq %r11
    movq %rdi, %rsi # restore the current node into rsi
    movq 12(%rsi), %rax 
    movq %r9, %rbx
    jmp check_sorted_HW1  

    

check_sorted_HW1:
    movq $1, %r13 # increasing flag = true
    movq $1, %r14 # decreasing flag = true

    testq %rax, %rax 
    je is_sorted_HW1  # check if start is null

    testq %rbx, %rbx 
    je is_sorted_HW1  # check if end is null

    movq %rax, %rsi

// check if list is sorted, asume the start node = rax, end node = rbx
check_sorted_loop_HW1:

    cmpq %rbx, %rsi            # Compare current->next (12 bytes offset) with end
    je check_sorted_loop_end_HW1      # If current->next == end, jump to loop_end

    movq 12(%rsi), %rdx #   rdx = current->next  

    movsxd 8(%rdx), %rcx  #   rcx = current->next->data

    movsxd 8(%rsi), %rdx      # rax = (signed) current->data
    
    

    
    cmpq  %rcx ,%rdx # check if current->next->data < current->data 
    jg set_not_increasing_HW1

continue_sorted_loop1_HW1:
    cmpq  %rcx ,%rdx # check if current->next->data > current->data
    jl set_not_decreasing_HW1

continue_sorted_loop2_HW1:
    movq 12(%rsi), %rsi     # Move to the next node (current = current->next)
    jmp check_sorted_loop_HW1         # Repeat the loop    

set_not_increasing_HW1: 
    movq $0, %r13
    jmp continue_sorted_loop1_HW1

set_not_decreasing_HW1:
    movq $0, %r14
    jmp continue_sorted_loop2_HW1

check_sorted_loop_end_HW1:
    cmpq $1 ,%r13 # check if increasing seria
    je is_sorted_HW1 

    cmpq $1 ,%r14  # check if decreasing seria
    je is_sorted_HW1

    jmp next_node_HW1

is_sorted_HW1:
    cmpq $0, %r11
    je check_right_side_HW1
    jmp set_sort_count_HW1
set_sort_count_HW1:
    incq %r10        # inc coount if the left and the right side is sorted

next_node_HW1:
    jmp all_nodes_loop_HW1

set_result_HW1:
    movq %r10, result
    jmp done_HW1

done_HW1:
