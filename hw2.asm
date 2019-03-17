##############################################################
# Homework #2
# name: Matthew Lombardo
# scccid: 01177432
##############################################################
.data
upperLength:	.word 20
buffer:	.space 256
nullBuffer: .asciiz "0"
.text

##############################
# PART 1 FUNCTIONS 
##############################

toUpper: 
	### Register Usage
	# $a0 = The original String Argument
	# $t1 = Length Counter. Goes up once per loop.
	# $t2 = The current byte of the string.
	# $s0 = The address of $a0.
	# $s1 = The address of theString.
	
	li $t1, 0
	la $s0, ($a0)
	la $s1, buffer
	upperLoop:  
    		lb $t2, 0($s0)  # $t2 = the first character of $s0.
    		beq $t2, 0x0, upperEnd   # if $t2 == 0 then go to label end  
    		blt $t2, 'a', notUpper   # if $t2 is an ASCII value less than 'a', skip ahead
    		bgt $t2, 'z', notUpper   # if $t2 is an ASCII value greater than 'z', skip ahead
    		subi $t2, $t2, 32        # set the lowercase value to uppercase
    	notUpper:
    		sb $t2, ($s1)            # store the old byte back where it belongs
    		add $s1, $s1, 1		# Increment the address of the buffer.
    		add $s0, $s0, 1        # Increment the address of the argument.
    		add $t1, $t1, 1        # Increment the $t1 counter.
    		j upperLoop      # finally loop  
    
upperEnd:
	# Save buffer to $v0 and jump back
	la $v0, buffer
	jr $ra

		

length2Char:
	#Define your code here
	### Register Usage
	# $a0 = String Argument.
	# $a1 = Argument Character.
	# $t1 = length2Char counter.
	# $t2 = The current character of the string.
	# $t3 = The breaker character.
	# $v0 = Final Output.
	li $t1, 0
	lb $t3, 0($a1)
	
	length2Loop:  
    		lb $t2, 0($a0)  # $t2 = the first character of $s0.
    		beq $t2, 0x0, length2End   # if $t2 == 0 then go to label end 
    		beq $t2, $t3, length2End
    		add $t1, $t1, 1        # Increment the $t1 counter.
    		add $a0, $a0, 1
    		j length2Loop      # finally loop  
   
length2End:
	# Save buffer to $v0 and jump back
	move $v0, $t1
	jr $ra

strcmp:
	### Register Usage
	# $a0 = Argument Input 1
	# $a1 = Argument Input 2
	# $a2 = Length
	# $v0 = Number of characters in string that matched.
	# $v1 = Indicates whether a match was found. 1 = Yes, 0 = No
	# $s0 = Storage for $a0
	# $s1 = Storage for $a1
	# $s2 = Storage for $ra
	# $t0 = $a0[i]
	# $t1 = $a1[i]

	
	# If length ($a2) < 0, invalid response and return 0.
	bltz $a2, strcmpInvalid
	# If length > 0 and length > $a0.length or $a1. length, invalid response and return 0. 
	
	# Get length of first string and compare
	move $s0, $a0
	move $s1, $a1
	la $a1, nullBuffer
	la $s2, ($ra)
	jal length2Char
	move $ra, $s2
	bgt $a2, $v0, strcmpInvalid
	# bgt $v0, $a2, strcmpLessThanZero
	# get length of second string and compare
	move $a0, $s1
	la $a1, nullBuffer
	la $s2, ($ra)
	jal length2Char
	move $ra, $s2
	bgt $a2, $v0, strcmpInvalid
	# bgt $v0, $a2, strcmpInvalid
	# If length > 0 and length < $a0.length and $a1.length...
	# $v1 = 1;
	li $v0, 0
	li $v1, 1
	move $a0, $s0
	move $a1, $s1
	# for i = 0; i < length; i++...
	strcmpLoop:
		addi $v0, $v0, 1
		bgt $v0, $a2, strcmpLoopEnd
		# Load $a0[i] to $t0
		lb $t0, 0($a0)
		# Load $a1[i] to $t1
		lb $t1, 0($a1)
		# if $t1 == $t2, $v0++
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		beq $t0, $t1, strcmpLoopTrue
		# else, $v1 = 0 and break.
		j strcmpLoopFalse
	strcmpLoopTrue:
		j strcmpLoop
	strcmpLoopFalse:
		li $v1, 0
		subi $v0, $v0, 1
		jr $ra
	# if $a0[i] == $a1[i], $v0++. else, $v1 = 0..
	#Define your code here
	strcmpLoopEnd:
	subi $v0, $v0, 1
	jr $ra
	
strcmpInvalid:
	li $v0, 0
	li $v1, 0
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	#Define your code here
	
	### Register Usage
	# $a0 = Initial string.
	# $a1 = Where the final string will be stored.
	# $a2 = Size argument.
	# $v0 = First return integer. Returns the length of the morse code string, including the null terminator.
	# $v1 = Second return integer. 1 if the morse code string fit. 0 if it didn't or an error occurred.
	
	# $s0 = Loop Counter.
	# $s1 = $a0.length
	move $s2, $a0
	move $s3, $a1
	move $s4, $a2
	li $a2, 0
	la $s5, ($ra)
	jal length2Char
	move $s1, $v0
	la $ra, ($s5)
	
	move $a0, $s2
	move $a1, $s3
	move $a2, $s4
	
	
	# $v1 = 1;
	li $v1, 1
	li $v0, 0
	li $s0, 0
	# $s1 = $a0.length
	
	# for int i  = 0; i < $s1; i++ {
	toMorseLoop:
	# 	$v0++; (Increment up length.)
		addi $v0, $v0, 1
	#	i++;
		addi $s0, $s0, 1
		beq $s0, $s1, toMorseEnd
		bgt $s0, $s1, toMorseEnd
	# 	if i > $a2, $v1 = 0 and break.;
		bgt $s0, $a2, toMorseBigger
	# 	$t0 = $a0[i]; ($t0 = the current character of the argument string.)
		lb $t0, 0($a0)
		addi $a0, $a0, 1
		# Minus 20 in hex to account for Array Placement
		subi $t0, $t0, 0x20
	# 	$t4 = MorseCode[$t0]; ($t1 = the morse code character.)
		li $t3, 0
		li $t1, 0
		la $t5, MorseCode
		move $t2, $t0          # put the index into $t2
    		add $t2, $t2, $t2    # double the index
    		add $t2, $t2, $t2    # double the index again (now 4x)
    		add $t1, $t2, $t5    # combine the two components of the address
    		lw $t4, ($t1)       # get the value from the array cell
	# 	$a1[i] = $t4; (set the character into the $a1 space.)
		sw $t4, ($a1)
		addi $a1, $a1, 4
	# }
		j toMorseLoop
	toMorseEnd:
		jr $ra
	toMorseBigger:
		li $v1, 0
		j toMorseEnd

createKey:
	### Register Usage
	# $a0 = Initial String
	# $a1 = Address for Key Array
	# $v0 = toUpper String
	
	# get the toUpper variant of the string
	la $s7, ($ra)
	jal toUpper
	la $ra, ($s7)
	
	la $t5, ($a1)
	# for each character in the string
	createKeyStringLoop:
    		lb $t2, 0($v0)  # $t2 = the first character of $v0
    		beq $t2, 0x0, createKeyStringEnd   # if $t2 == 0 then go to label end 
    		add $v0, $v0, 1
		# if the character hasn't been seen yet and is in the alphabet, add it to the key array
		blt $t2, 'A', createKeyContinueLoop
		bgt $t2, 'Z', createKeyContinueLoop
		# $t5 = Placement of keyIndex we're up to 
		# $t0 = Address of $a1 to increment up through keyIndex
		# $t3 = Current character in the string from the start.
		la $t0, ($a1)
		createKeyInnerLoop:
			lb $t3, 0($t0)
			beq $t3, 0x0, createKeyNotInIndex
			bne $t3, $t2, createKeyAfterInnerLoop
    			j createKeyContinueLoop      # finally loop  
    		createKeyAfterInnerLoop:
    			addi $t0, $t0, 1
    			j createKeyInnerLoop      # finally loop  
    		createKeyNotInIndex:
    			# Add to array
    			sb $t2, ($t5)
    			addi $t5, $t5, 1
    			j createKeyContinueLoop
    	createKeyContinueLoop:
    		j createKeyStringLoop
    	createKeyStringEnd:
    	
	# end loop
	# for each character in the alphabet
	li $t2, 'A'
	
	createKeyAlphaLoop:
		bgt $t2, 'Z', createKeyAlphaEnd
		la $t0, ($a1)
		createKeyAlphaInnerLoop:
			lb $t3, 0($t0)
			beq $t3, 0x0, createKeyAlphaNotInIndex
			bne $t3, $t2, createKeyAlphaAfterInnerLoop
    			j createKeyAlphaContinueLoop      # finally loop  
    		createKeyAlphaAfterInnerLoop:
    			addi $t0, $t0, 1
    			j createKeyAlphaInnerLoop      # finally loop  
    		createKeyAlphaNotInIndex:
    			# Add to array
    			sb $t2, ($t5)
    			addi $t5, $t5, 1
    			j createKeyAlphaContinueLoop
    	createKeyAlphaContinueLoop:
    		addi $t2, $t2, 1
    		j createKeyAlphaLoop
    		
	createKeyAlphaEnd:
		# if the character isn't in the key yet, add it to the key array
	# end loop
	
	
	jr $ra

keyIndex:
	#Define your code here
	### REGISTER USAGE
	# $a0 = Initial Morse String
	# $v0 = Return Value
	
	# Get first three characters of the string
	
	# $v0 = 0
	
	# While not at the end of FMorseCipherArray
	# If at the end of the Array, $v0 = -1 and return
	# If the first three characters of FMorseCipherArray == the first three characters of the string
		# Return i an break loop
	# Else, increment FMorseCipherArray by 3 and i by one, and continue the loop.
	
	jr $ra

FMCEncrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra



.data

MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 

MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."


FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"

