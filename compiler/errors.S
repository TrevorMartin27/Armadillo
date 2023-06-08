
.include "compiler/syscalls.h"

STDERR = 2

.text

msg_not_implemented:
	.ascii "[ERROR] Not Implemented.\n"
msg_not_implemented_length = . - msg_not_implemented

.text

###########################################################################################
# error_throw_string will print out the buffer of length rdx and stored in rsi to stderr. #
# It will also exit with a return code of 1. For that reason it can be evoked with either #
# call or jmp (or jmp-family functions).                                                  #
###########################################################################################

.global error_throw_string
error_throw_string:
	mov $SYSCALL_WRITE, %rax                     # Write
	mov $STDERR, %rdi                            #   to stderr
	# Buffer already in rsi                      #   the buffer
	# Length already in rdx
	syscall

	mov $SYSCALL_EXIT, %rax                      # Exit
	mov $1, %rdi                                 #   with status code 1
	syscall

########################################################################################
# error_not_implemented is to be used for temporary code, as it's a simple way to just #
# panic if we reach a code path that we haven't yet implemented. In the near future,   #
# it should be removed.                                                                #
########################################################################################

.global error_not_implemented
error_not_implemented:
	lea (msg_not_implemented), %rsi
	mov $msg_not_implemented_length, %rdx
	jmp error_throw_string
