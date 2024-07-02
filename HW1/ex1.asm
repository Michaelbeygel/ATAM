.global _start

.section .text
_start:
#your code here
    # Load the address of the array into RSI
    movq Address, %rsi

    # Load the index into RAX
    movq Index, %rax

    # Load the length into RBX
    movq length, %rbx

    # Compare the index with the length
    cmpq %rbx, %rax
    jae not_legal_HW1  # If index >= length, set Legal to 0

    # If the index is legal, set Legal to 1
    movl $1, Legal

    # Calculate the address of the element (each element is 4 bytes), effective address = base + 4*index
    leaq (%rsi,%rax,4), %rdi

    # Load the element into EAX
    movl (%rdi), %eax

    # Store the element into num
    movl %eax, num

    # Exit the program
    jmp exit_HW1

not_legal_HW1:
    # If the index is not legal, set Legal to 0
    movl $0, Legal

exit_HW1: 