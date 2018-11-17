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
 
    print_empty:
    la $a0, input_is_empty                      # load address of the string to print
    li $v0, 4                                   # load code to print string
    syscall
    jal exit 
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
    
    li $s2, 1                                   
    la $a1, filtered_input                      # load address of filtered_input
    sb $t0, 0($a1)
    lb $t0, 1($a0)
    sb $t0, 1($a1)
    lb $t0, 2($a0)
    sb $t0, 2($a1)
    lb $t0, 3($a0)
    sb $t0, 3($a1)
    addi $a0, $a0, 3           
    
    skip:
    addi $a0, $a0, 1
    jal filter_loop

    exit_filter_loop:
    beqz $s2, print_empty  				# If $s2 is still 0, it means tuser input is empty or the has only spaces
    
    li $s0, 1                                   # number to multiply 36 with after each iteration of valid char
    li $s1, 0                                   # sum number based on calculation in each iteration
    li $s4, 0                                   # loop counter
    li $s6, 0                                   # will be updated to 1 when a non-space, non-NUL or non-new-line-char is found. If this is already 1 and space is found, jump to print_invalid_value
    la $a0, filtered_input                      # $a0 now holds the address of the first byte of filtered_input
    addi $a0, $a0, 4 
    
    li $t5, 4
    beq $t5, $s4, loop_exit
    addi $s4, $s4, 1                            
    addi $a0, $a0, -1                           

    lb $t2, 0($a0)                              
    beqz $t2, loop                              

    li $a1, 10                                  
    beq $a1, $t2, loop                         

    li $s7, 32                                  
    beq $t2, $s7, handle_space                  


    li $s6, 1
    
    # Now that $t2 does not have NUL or new line char, check if the char is valid in 36-base system
    li $t0, 47
    slt $t1, $t0, $t2
    slti $t4, $t2, 58
    and $s5, $t1, $t4                           # if $t2 has value within range 48 and 57, $s5 will have 1, else 0
    addi $s3, $t2, -48                          
    li $t7, 1
    beq $t7, $s5, calculation
    
    li $t0, 64
    slt $t1, $t0, $t2
    slti $t4, $t2, 91
    and $s5, $t1, $t4                           #if $t2 has value within range 65 and 90, $s5 will have 1, else 0
    addi $s3, $t2, -55                        
    li $t7, 1
    beq $t7, $s5, calculation 
    
    li $t0, 96
    slt $t1, $t0, $t2				#if $t2 has value within range 97 and 122, $s5 will have 1, else 0
    slti $t4, $t2, 123

calculation:
    mult $s0, $s3                               # $s0 has the required power of 36 and $s3 is the value of valid char in 36-base number system
    mflo $t3
    add $s1, $s1, $t3
    
    li $t6, 36
    mult $s0, $t6
    mflo $s0
    jal loop

	
exit:
    li $v0, 10                                  # load code to exit the program
    syscall
