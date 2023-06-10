
.include "compiler/syscalls.h"

STDOUT = 1

.text

.global codegen_string
codegen_string: # (%rsi: buffer, %rdx: length) -> ()
	push %rax                                    # Save register state
	push %rcx
	push %rdx
	push %rsi
	push %rdi

	mov $SYSCALL_WRITE, %rax                     # Write
	mov $STDOUT, %rdi                            #   to stdout
	# Buffer already in rsi                      #   the buffer
	# Length already in rdx
	syscall

	pop %rdi                                     # Load register state
	pop %rsi
	pop %rdx
	pop %rcx
	pop %rax

	ret                                          # Return

.global codegen_cstring
codegen_cstring: # (%rsi: string) -> ()
	# TODO: Do we want to move the syscall in codegen_string into this function?
	#   that way, we don't need to push as much.

	push %rax                                    # Save register state
	push %rdx

	mov %rsi, %rax                               # Get string length
	call string_length
	mov %rax, %rdx

	call codegen_string                          # Generate string

	pop %rdx                                     # Load register state
	pop %rax

	ret                                          # Return

.global codegen_uid
codegen_uid:
	jmp error_not_implemented
