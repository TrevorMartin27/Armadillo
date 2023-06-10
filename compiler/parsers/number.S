
.text

asm_number_0:
	.ascii "\tmovq $"
asm_number_0_len = . - asm_number_0

asm_number_1:
	.ascii ", (%r8)\n\tadd $8, %r8\n"
asm_number_1_len = . - asm_number_1

.text

.global parse_number
parse_number: # (), current_token -> ()
	# NOTE: This will trample %rsi, %rdx

	lea (asm_number_0), %rsi
	mov $asm_number_0_len, %rdx
	call codegen_string

	lea (current_token), %rsi
	call codegen_cstring

	lea (asm_number_1), %rsi
	mov $asm_number_1_len, %rdx
	call codegen_string

	ret
