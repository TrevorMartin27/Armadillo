
.text

asm_call_0:
	.ascii "\tcall "
asm_call_0_len = . - asm_call_0

asm_call_1:
	.ascii "\n"
asm_call_1_len = . - asm_call_1

.text

.global parse_call
parse_call: # (), current_token -> (), current_token
	# NOTE: This will modify current_token
	lea (current_token), %rax
	call string_snake

	lea (asm_call_0), %rsi
	mov $asm_call_0_len, %rdx
	call codegen_string

	lea (current_token), %rsi
	call codegen_cstring

	lea (asm_call_1), %rsi
	mov $asm_call_1_len, %rdx
	call codegen_string

	ret
