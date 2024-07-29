.global count_above

.section .text
count_above:
  # %rdi = separator param stored here by convension
  # %rsi = limit param stored here by convension


  # Backup caller registers
  call get_path  # retured path in %rax
  # restore registers 

  # param pass by this registers so we need to store them before using
  push %rdi 
  push %rsi
  # syscall open file
  mov %rax, %rdi # set %rdi with the path file
  mov $2, %rax
  mov $0, %rsi
  syscall
  mov %rax, %r15 # moving retuned Descriptor

  pop %rsi
  pop %rdi

  xor %r10, %r10 # init counter

init_stack:
  mov %rbp , %rsp # set stack pointer to the end of the stack
  mov %rbp, %r8

read_loop:
  # param pass by this registers so we need to store them before using
  inc %rsp
  push %rdi
  push %rsi
  #  syscall read byte from file
  mov $0, %rax
  mov %r15, %rdi
  mov %r8, %rsi
  mov $1, %rdx
  syscall # syscall use %rcx
  # in %rax will be the number of bytes the actualy we read
  pop %rsi
  pop %rdi

  inc %r8

  # Check if we reached the end of the file
  cmp %rax, 0                 # Compare the return value to 0
  je close_file

  # check byte equals separator
  cmp %rax ,%rdi
  je compare_num
  jmp read_loop

compare_num:
  push $0
  push %rdi
  push %rsi
  mov %rbp, %rdi
  call atam_atol
  pop %rsi
  pop %rdi
  cmp %rax, %rsi
  jg increment_counter
  jmp init_stack

increment_counter:
  inc %r10
  jmp init_stack

close_file:
  mov %rbp, %rsp # set stack pointer to the end of the stack
  # close file
  mov $3, %rax
  mov %r15, %rdi
  syscall

  # return counter
  mov %r10, %rax
  
  ret


