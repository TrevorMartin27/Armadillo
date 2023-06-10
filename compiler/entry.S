
.include "compiler/syscalls.h"

.text

.global _start
_start:
	call next_token                              # Read next token

	call parse_statement

	mov $SYSCALL_EXIT, %rax                      # Exit with length as status code
	mov $0, %rdi
	syscall
