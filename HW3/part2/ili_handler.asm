.globl my_ili_handler

.text
.align 4, 0x90

my_ili_handler:
# using r15 as addition to stack pointer, backing it up first
  pushq %r15
# backing up rest of registers
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
  xor %rdi, %rdi
  xor %rbx, %rbx
  xor %rax, %rax
  xor %r15, %r15

  # Calculate the correct offset to the saved RIP
  movq 120(%rsp), %rbx       # Store current stack pointer in rbx ( 15 registers of 8 bytes)

  # Retrieve the RIP from the stack
  movq (%rbx), %rbx     # RIP command address is now in RBX
  movb %bl, %al      # Get the first byte of the command
  movq %rax, %rdi
  cmp $0x0F, %rdi   # Check if command size is 2 bytes
  je two_bytes
  call what_to_do
  movq $1, %r15
  jmp restore_registers

two_bytes:
  xor %rax, %rax
  movb %bh, %al
  movq %rax, %rdi
  call what_to_do
  movq $2, %r15

restore_registers:
  movq %rax, %rdi # Restore the return value of what to do in RDI
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
  addq %r15, 8(%rsp) # pointing rip to next command, rip is 8 higher than due to r15 in stack
  popq %r15
  jmp end

old_ili:
  popq %r15
  jmp * old_ili_handler

end:
  iretq
