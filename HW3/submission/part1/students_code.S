.global count_above

.section .text
count_above:
  # %rdi = separator param stored here by convension
  # %rsi = limit param stored here by convension

  # backup callee registers
  push %rbp
  mov %rsp, %rbp
  push %rbx
  push %r12
  push %r13
  push %r14
  push %r15

  call get_path  # returned path in %rax

  # param pass by this registers so we need to store them before using
  mov %rdi, %r13 
  mov %rsi, %r12
  # syscall open file
  mov %rax, %rdi # set %rdi with the path file
  mov $2, %rax # syscall number for open
  mov $0, %rsi # read only
  syscall
  mov %rax, %r15 # moving retuned Descriptor

  xor %r10, %r10 # init counter
  subq $20, %rsp # init stack space
  mov %rsp, %r14 # init stack pointer

init_stack:
  mov %r14 , %rsp # set stack pointer to the end of the stack

read_loop:
  # param pass by this registers so we need to store them before using
  #  syscall read byte from file
  mov $0, %rax # syscall number for read
  mov %r15, %rdi # file descriptor
  mov %rsp, %rsi # buffer address
  mov $1, %rdx # read one byte
  syscall # syscall use %rcx
  # in %rax will be the number of bytes the actualy we read
  mov %rax, %r9 # save the number of bytes read
  inc %rsp # allocate 1 byte for writing

  # Check if we reached the end of the file
  cmp $0, %r9                 # Compare the return value to 0
  je compare_num # If the return value is 0, we reached the end of the file

  # check byte equals separator
  movzbl -1(%rsp), %ebx # get the last byte read
  cmp %rbx ,%r13 # compare it with the separator
  je compare_num # if it is equal to the separator we need to compare the number
  jmp read_loop # if it is not equal to the separator we need to read the next byte

compare_num:
  dec %rsp # remove the last byte read
  movb $0, (%rsp) # add null terminator
  mov %r14, %rdi # set the string address
  mov %r14, %rsp
  push %r10
  push %r9
  call atam_atol
  pop %r9
  pop %r10  
  cmp %r12, %rax  # compare the number with the limit
  jle check_if_done # if the number is less than the limit we need to read the next number


increment_counter:
  inc %r10 

check_if_done:
  cmp $0, %r9 # check if we reached the end of the file
  jne read_loop

close_file:
  mov $3, %rax
  mov %r15, %rdi
  syscall

  # return counter
  mov %r10, %rax

  # Restore caller registers
  pop %r15
  pop %r14
  pop %r13
  pop %r12
  pop %rbx
  leave
  ret


