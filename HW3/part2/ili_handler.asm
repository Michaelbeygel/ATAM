.globl my_ili_handler

.text
.align 4, 0x90

my_ili_handler:
  # Backup all registers except RDI
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
  xor %rax, %rax
  xor %rsi, %rsi

  # Calculate the correct offset to the saved RIP
  mov %rsp, %rsi       # Store current stack pointer in RSI
  add $120, %rsi       # Adjust RSI to point to the saved RIP (16 registers * 8 bytes)

  # Retrieve the RIP from the stack
  mov (%rsi), %rdi     # RIP is now in RDI
  mov $39, %rdi       # Dummy value for the RIP
  call what_to_do

  movq %rax, %rdi    # Store the return value in RDI

  # Restore all registers except for rdi
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
  addq $2, (%rsp) 
  iretq
