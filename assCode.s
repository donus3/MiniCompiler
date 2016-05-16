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

	xor %rax, %rax
	movq %rax,-48(%rbp)

	movq $1,%rax
	push %rax

	movq $5,%rax
	push %rax

	pop %rcx
LOOP0 :
	pop %rax
	cmp %rax,%rcx
	jl LE0
	movq %rax,-8(%rbp)
	push %rcx
	push %rax

	leaq .show, %rdi
	movq -8(%rbp),%rsi
	xor %rax, %rax
	call printf

	movq $3,%rax
	push %rax

	movq $4,%rax
	push %rax

	movq $1,%rax
	push %rax

	pop %rbx
	pop %rax
	add %rbx, %rax
	push %rax

	pop %rbx
	pop %rax
	imul %rbx
	push %rax

	movq $5,%rax
	push %rax

	pop %rbx
	pop %rax
	sub %rbx, %rax
	push %rax

	pop %rax
	movq %rax,-16(%rbp)

	leaq .show, %rdi
	movq -16(%rbp),%rsi
	xor %rax, %rax
	call printf

	pop %rax
	inc %rax
	pop %rcx
	push %rax
	jmp LOOP0 
LE0 :

	movq $5,%rax
	push %rax

	pop %rbx
	movq -8(%rbp), %rax
	cmp %rax,%rbx
	jnz IF0

	movq $60,%rax
	push %rax

	movq $6,%rax
	push %rax

	pop %rbx
	pop %rax
	xor %rdx, %rdx
	idiv %rbx
	push %rdx

	pop %rax
	movq %rax,-8(%rbp)

	movq $5000,%rax
	push %rax

	pop %rax
	movq %rax,-16(%rbp)

IF0 :

	leaq .showstring, %rdi
	leaq .s0, %rsi
	xor %rax, %rax
	call printf

	leaq .show, %rdi
	movq -8(%rbp),%rsi
	xor %rax, %rax
	call printf

	leaq .showstring, %rdi
	leaq .s1, %rsi
	xor %rax, %rax
	call printf

	leaq .show, %rdi
	movq -16(%rbp),%rsi
	xor %rax, %rax
	call printf

	movq $4,%rax
	push %rax

	movq $8,%rax
	push %rax

	pop %rbx
	pop %rax
	sub %rbx, %rax
	push %rax

	pop %rax
	movq %rax,-24(%rbp)

	movq $4,%rax
	push %rax

	pop %rbx
	 movq $0, %rax
	sub %rbx, %rax
	push %rax

	pop %rax
	movq %rax,-32(%rbp)

	movq -24(%rbp), %rax
	movq %rax, -48(%rbp)

	movq -24(%rbp), %rbx
	movq -32(%rbp), %rax
	cmp %rax,%rbx
	jnz IF1

	leaq .showstring, %rdi
	leaq .s2, %rsi
	xor %rax, %rax
	call printf

IF1 :

	leaq .show, %rdi
	movq -48(%rbp),%rsi
	xor %rax, %rax
	call printf

	movq $4,%rax
	push %rax

	movq $3,%rax
	push %rax

	 xor %rdx, %rdx
	pop %rbx
	pop %rax
	idiv %rbx
	push %rax

	leaq .show, %rdi
	pop %rsi
	xor %rax, %rax
	call printf

	add $216, %rsp
	ret
.data
	.show: .string " %d \n" 
	.showstring: .string " %s \n" 

	.s0: .string "A value is"

	.s1: .string "B value"

	.s2: .string "d equal c"

