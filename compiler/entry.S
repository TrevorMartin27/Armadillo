
.include "compiler/syscalls.h"

.text

.global _start
_start:
	call next_token                              # Read next token

	lea (current_token), %rax                    # Get token length
	call string_length
	mov %rax, %rdi

	mov $SYSCALL_EXIT, %rax                      # Exit with length as status code
	# mov $0, %rdi
	syscall
