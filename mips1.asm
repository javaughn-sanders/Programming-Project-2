.data
    userInput:    .space 64
    emptyInput:   .asciiz "Input is empty."
    invalidInput: .asciiz "Invalid base-36 number."
    longInput:    .asciiz "Input is too long."
   filtered_input:     .space 4                        # allocate 4 bytes for filtered out string that doesn't have white spaces
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
	
filter_loop:
    lb $t0, 0($a0)                              # load byte from $a0, $a0 currently points to first byte of user input and is updated in the loop
    beq $t0, $t1, exit_filter_loop              # exit when new line char found
    beq $t0, $t2, skip                          
    beqz $t0, exit_filter_loop                  # exit loop when NUL is found

    bne $s2, $zero, error_long_input
	
exit:
    li $v0, 10                                  # load code to exit the program
    syscall
