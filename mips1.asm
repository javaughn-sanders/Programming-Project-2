.data
UserInput:
    userInput:    .space 64
    emptyInput:   .asciiz "Input is empty."
    invalidInput: .asciiz "Invalid base-36 number."
    longInput:    .asciiz "Input is too long."

.text


error_emp_input:
  la $a0, emptyInput
  li $v0, 4
  syscall
  j exit
  
error_inv_input:
  la $a0, invalidInput
  li $v0, 4
  syscall
  j exit
  
error_long_input:
  la $a0, longInput
  li $v0, 4
  syscall
  j exit
  
main:
 	li      $v0, 8 		#op code for reading strings
	la      $a0, userInput  #load UserInput from emeory and store in argument reqister 0
	li      $a1, 64  	# how much memory to give user to input string
	syscall
    
# Use a loop to extract string and exclude white spaces
    li $s2, 0                                  						 
    li $t1, 10                                 
    li $t2, 32
	
exit:
    li $v0, 10                                  # load code to exit the program
    syscall
