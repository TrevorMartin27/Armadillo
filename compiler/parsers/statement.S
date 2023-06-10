
.text

startswith_digit: # (%al: character) -> flags
	cmp $'0', %al                                # Check if digit >= '0'
	jl swd_return
	cmp $'9', %al                                # Check if digit <= '9'
	jg swd_return

	cmp %rsp, %rsp                               # If so ('0' <= digit <= '9'), set the equals flag to true
swd_return:
	ret

.global parse_statement
parse_statement: # (), current_token -> ()
	#### Register Usage ####
	#  al - Current character
	# rdx - TRAMPLED
	# rsi - TRAMPLED

	push %rax
	push %rdx
	push %rsi

	mov (current_token), %al

ps_check0:
	call startswith_digit
	jne ps_check1
	call parse_number
	jmp ps_return
ps_check1:
	jmp error_not_implemented
ps_return:

	pop %rsi
	pop %rdx
	pop %rax
	
	ret
