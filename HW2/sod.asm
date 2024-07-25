.section .data
buf:	.int 0
A:		.int  2
		.quad B
		.quad C
B:		.int 3
		.quad D
		.quad E
C:		.int 4
		.quad 0
		.quad 0
D:		.int 3
		.quad 0
		.quad 0
E:		.int 1
		.quad F
		.quad 0
F:		.int 1
		.quad 0
		.quad G
G:		.int 1
		.quad 0
		.quad 0



.global _start, sod
.section .text


_start:
  leaq A, %rdi
  movl $1, %esi
  call sod
  movq %rax, buf
  leaq buf, %rsi
  movl $1, %eax
  movl $1, %edi
  movl $1, %edx
  syscall
  movq $60, %rax
  movq $0, %rdi
  syscall
sod:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -24(%rbp)
  movq %esi, -28(%rbp)
  cmpq $0, -24(%rbp)
  jne .L2
  movl $1, %eax
  jmp .L3
.L2:
  addl $1, -28(%rbp)
  movq -24(%rbp), %rax

  movq 4(%rax), %rax
  movl -28(%rbp), %edx
  movl %edx, %esi
  movq %rax, %rdi
  call sod
  movl %eax, -4(%rbp)
  movq -24(%rbp), %rax
  movq 12(%rax), %rax
  movl -28(%rbp), %edx
  movl %edx, %esi
  movq %rax, %rdi
  call sod
  movl %eax, -8(%rbp)
  movl -4(%rbp), %eax
  imull -8(%rbp), %eax
  movl -28(%rbp), %edx
   imull %edx, %eax
  movl %eax, -12(%rbp)
  movq -24(%rbp), %rax
  movl (%rax), %eax
  imull -12(%rbp), %eax
  movl %eax, %edx
  movq -24(%rbp), %rax
  movl %edx, (%rax)
  movq -24(%rbp), %rax
  movl (%rax), %eax
.L3:
  leave
   ret

