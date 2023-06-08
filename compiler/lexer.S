
.include "compiler/syscalls.h"

MAX_TOKEN_LENGTH = 16

EOF = 0

STDIN = 0

.data

current_character:
	.zero 1

.global current_token
current_token:
	.zero MAX_TOKEN_LENGTH+1

.text

msg_token_overflow:
	.ascii "[ERROR] Token Too Long.\n"
msg_token_overflow_length = . - msg_token_overflow

.text

#########################################################################################
# next_character will read the next character from stdin into current_character and al. #
# Note: It will trample rax, rcx, rdx, rsi, and rdi.                                    #
#########################################################################################

next_character: # () -> (%al: character), current_character
	mov $SYSCALL_READ, %rax                      # Read
	mov $STDIN, %rdi                             #   from stdin
	lea (current_character), %rsi                #   to current_character
	mov $1, %rdx                                 #   1 character
	syscall

	cmp $1, %rax                                 # Check if we successfully read the character
	je nc_return

	movb $EOF, (current_character)               # If there was either an error or we reached the end,
	                                             #   just say that we reached the end
nc_return:
	mov (current_character), %al                 # Load the current character into al

	ret                                          # Return

######################################################################################
# is_seperator will update the ZF flag based on if current_character is a seperator. #
# So, if it's a space, newline, tab, carriage return, or end of file.                #
# Note: It will trample rax.                                                         #
######################################################################################

is_seperator: # () -> flags
	cmp $' ', %al                                # Check for space
	je is_return
	cmp $'\r', %al                               # Check for carriage return
	je is_return
	cmp $'\t', %al                               # Check for tab
	je is_return
	cmp $'\n', %al                               # Check for newline
	je is_return
	cmp $EOF, %al                                # End of file
	je is_return
is_return:
	ret                                          # Return

############################################################################################
# next_token will read the next whitespace-seperated token from stdin to the current_token #
# buffer. Note that a string literal will parse until a double quote (not just the next    #
# whitespace seperator). If reading the token into the buffer is longer then the buffer,   #
# it will panic, throw an error, and exit. It will not trample any registers.              #
############################################################################################

.global next_token
next_token: # () -> current_token
	#### Register Usage ####
	#  al - Current character
	# rbx - Write pointer
	#  r8 - Token length
	# rcx - TRAMPLED BY SYSCALLS
	# rdx - TRAMPLED BY SYSCALLS
	# rsi - TRAMPLED BY SYSCALLS
	# rdi - TRAMPLED BY SYSCALLS

	push %rax                                    # Save register state
	push %rbx
	push %r8
	push %rcx
	push %rdx
	push %rsi
	push %rdi

	                                             # We don't need to clear rax, because we'll only look at lowest byte
	lea (current_token), %rbx                    # Write pointer
	mov $0, %r8                                  # Token length

nt_whitespace_loop:
	call next_character                          # Read next character

	cmp $EOF, %al                                # Check for end of file
	je nt_return                                 #   if so, return (will null-terminate)

	cmp $34, %al                                 # Check if its a string literal (not using '"' because Notepad++ annoying)
	je error_not_implemented                     #   for now, throw error (not implemented)

	call is_seperator                            # Check if its a seperator
	je nt_whitespace_loop                        #   if so, skip

nt_loop:
	cmp $MAX_TOKEN_LENGTH, %r8                   # Check if we would cause a buffer overflow
	jge nt_token_overflow                        #   if so, throw error

	mov %al, (%rbx)                              # Read byte into token buffer
	inc %rbx                                     #   advance write pointer
	inc %r8                                      #   increment token length

	call next_character                          # Read next character

	call is_seperator                            # Check if we reached seperator (or end of file)
	jne nt_loop                                  #   if so, null-terminate the token and return

nt_return:
	movb $0, (%rbx)

	pop %rdi                                     # Restore register state
	pop %rsi
	pop %rdx
	pop %rcx
	pop %r8
	pop %rbx
	pop %rax

	ret                                          # Return

nt_token_overflow:
	lea (msg_token_overflow), %rsi               # If reading the next character would overflow the token buffer, we will
	mov $msg_token_overflow_length, %rdx         # throw an error to avoid an (unlikely) segfault. We'll use throw_error_string
	jmp error_throw_string                       # because .ascii doesn't null terminate (but we have the length).
