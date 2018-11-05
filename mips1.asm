.data
UserInput:
    .space 64
.text
main:
 	li      $v0, 8 		#op code for reading strings
	la      $a0, UserInput  #load UserInput from emeory and store in argument reqister 0
	li      $a1, 64  	# how much memory to give user to input string
	syscall
