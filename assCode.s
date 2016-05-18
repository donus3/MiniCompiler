.global main
.text
main:
	movq %rsp,%rbp
	sub $216,%rsp

	xor %rax, %rax
	movq %rax,-8(%rbp)

	xor %rax, %rax
	movq %rax,-16(%rbp)

	xor %rax, %rax
	movq %rax,-24(%rbp)

	xor %rax, %rax
	movq %rax,-32(%rbp)

	movq $1,%rax
	push %rax

	pop %rax
	movq %rax,-8(%rbp)

	movq $2,%rax
	push %rax

	pop %rax
	movq %rax,-16(%rbp)

	movq $3,%rax
	push %rax

	pop %rax
	movq %rax,-24(%rbp)

	movq $0,%rax
	push %rax

	pop %rax
	movq %rax,-32(%rbp)

	movq -16(%rbp), %rbx
	movq -8(%rbp), %rax
	add %rbx, %rax
	push %rax

	movq -24(%rbp), %rbx
	pop %rax
	cmp %rax,%rbx
	jnz IF0

	movq $5,%rax
	push %rax

	movq $5,%rax
	push %rax

	movq $5,%rax
	push %rax

	movq $5,%rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	pop %rax
	movq %rax,-32(%rbp)

IF0 :

	leaq .show, %rdi
	movq -32(%rbp),%rsi
	xor %rax, %rax
	call printf

	movq $1,%rax
	push %rax

	movq $1,%rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	movq $1,%rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	movq $1,%rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	movq $1,%rax
	push %rax

	pop %rbx
	pop %rax
	sub %rbx, %rax
	push %rax

	pop %rbx
	movq -24(%rbp), %rax
	cmp %rax,%rbx
	jnz IF1

	leaq .showstring, %rdi
	leaq .s0, %rsi
	xor %rax, %rax
	call printf

IF1 :

	add $216, %rsp
	ret
.data
	.show: .string " %d \n" 
	.showstring: .string " %s \n" 

	.s0: .string "$c is 3"

