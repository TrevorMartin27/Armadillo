
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
