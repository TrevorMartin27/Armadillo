
.text

.global string_length
string_length: # (%rax: string) -> (%rax: length)
	#### Register Usage ####
	# rax - Character Pointer
	# rbx - String Length
	#  cl - Current Character

	push %rbx                                    # Save register state
	push %rcx

sl_loop_start:
	movb (%rax), %cl                             # Load current character

	cmp $0, %cl                                  # Check for null-termination
	je sl_loop_end                               #   if reached, break

	inc %rbx                                     # Increment string length
	inc %rax                                     # Increment character pointer

	jmp sl_loop_start
sl_loop_end:

	mov %rbx, %rax                               # Move string length into return register

	pop %rcx                                     # Restore register state
	pop %rbx

	ret                                          # Return

.global string_snake
string_snake: # (%rax: string) -> ()
	#### Register Usage ####
	# rax - Character Pointer
	#  bl - Current character
	
	push %rax
	push %rbx

	# TODO: I don't like this, reorganize to remove
	dec %rax
ss_loop_start:
	inc %rax
	movb (%rax), %bl

	cmp $0, %bl
	je ss_loop_end

	cmp $'-', %bl
	jne ss_loop_start

	movb $'_', (%rax)

	jmp ss_loop_start
ss_loop_end:

	pop %rbx
	pop %rax

	ret
