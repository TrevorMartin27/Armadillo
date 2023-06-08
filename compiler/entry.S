
.include "compiler/syscalls.h"

.text

.global _start
_start:
	call next_token
break0:
	mov $SYSCALL_EXIT, %rax
	mov $0, %rdi
	syscall

