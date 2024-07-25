.global count_above

.section .text
count_above:
  # Backup caller registers
  call get_path
  # get result from function
  # restore registers
  # syscall open file
  # loop:
  #   syscall read byte from file
  #   if byte == null termiator:
  #     jmp end
  #   write byte to register
  #   if byte is separator:
  #     write to memory
  #     call atam_atol
  #     if result > limit:
  #       counter += 1
  #     register = 0
  #   jmp loop


  # end:
  #   close file
  #   return counter
  ret


