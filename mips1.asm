.data
UserInput:
    userInput:    .space 64
    emptyInput:   .asciiz "Input is empty."
    invalidInput: .asciiz "Invalid base-33 number."
    longInput:    .asciiz "Input is too long."
.text


err_empty_input:
  la $a0, emptyInput
  li $v0, 4
  syscall
  j exit
  
main:
 	li      $v0, 8 		#op code for reading strings
	la      $a0, userInput  #load UserInput from emeory and store in argument reqister 0
	li      $a1, 64  	# how much memory to give user to input string
	syscall
    
	la $a0, UserInput 	#load address UserInput from memory and store it into arguement register 0
	li $v0, 4 		#loads the value 4 into register $v0 which is the op code for print string
	syscall
