.globl my_ili_handler

.text
.align 4, 0x90

my_ili_handler:
  pushq %rax
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rbp
  pushq %rsp
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15
  xor %rdi, %rdi
  xor %rbx, %rbx
  xor %rax, %rax

  # Calculate the correct offset to the saved RIP
  movq 120(%rsp), %rbx       # Store current stack pointer in rbx

  # Retrieve the RIP from the stack
  movq (%rbx), %rbx     # RIP command address is now in RBX
  movb %bl, %al      # Get the first byte of the command
  movq %rax, %rdi
  cmp $0x0F, %rdi   # Check if command size is 2 bytes
  je two_bytes
  call what_to_do
  jmp restore_registers

two_bytes:
  xor %rax, %rax
  movb %bh, %al
  movq %rax, %rdi
  call what_to_do

restore_registers:
  movq %rax, %rdi # Restore the return value of what to do in RDI
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rsp
  popq %rbp
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax

  cmp $0x0, %rdi # check if return value of what to do is 0
  je old_ili
  addq $2, (%rsp) 
  jmp end

old_ili:
  jmp * old_ili_handler

end:
  iretq
