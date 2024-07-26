.global count_above

.section .data
file_descriptor: .quad 0 # alocate 8 byte with 0

buffer: .zeros 20 # store here all the number (max 20 bytes)

.section .text
count_above:
  # %rdi = separator param stored here by convantion
  # %rsi = limit param stored here by convantion


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
  mov %rax, (file_descriptor) # moving retuned Descriptor

  pop %rsi
  pop %rdi

  xor %r10, %r10 # init counter


  read_loop:
  # param pass by this registers so we need to store them before using
  push %rdi
  push %rsi
  #  syscall read byte from file
  mov $0, %rax
  mov (file_descriptor), %rdi
  lea $buffer, %rsi
  mov $1, %rdx
  syscall # syscall use %rcx
  # in %rax will be the number of bytes the actualy we reed
  pop %rsi
  pop %rdi

  inc buffer

  # Check if we reached the end of the file
  cmp %rax, 0                 # Compare the return value to 0
  je close_file

  #  if byte == separator:
  cmp char ,%rdi
  je compare_num

compare_num:


  #   write byte to register
  #   if byte is separator:
  #     write to memory
  #     call atam_atol
  #     if result > limit:
  #       counter += 1
  #     register = 0
  jmp read_loop


close_file:
  # close file
  mov $3, %rax
  mov (file_descriptor), %rdi
  syscall

  # return counter
  mov %r10, %rax
  
  ret


