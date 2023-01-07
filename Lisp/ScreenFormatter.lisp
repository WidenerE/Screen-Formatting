#!/usr/bin/sbcl --script

(defvar tempVector)
(defvar padding)
(defvar padTemp)

;!Pre-Condition: The current line number for the output is calculated and
;passed in along with a boolean indicating whether the function should
;left or right align
;Post-Condition: The line number is padded to eight characters as either
;a left or right alignment and returned
(defun padString(localLineNum right)
	(setq padding (- 7 (length localLineNum)))
	(setq padTemp "")

	(loop for i from 0 to padding
		do(setq tempVector (make-array 1 :element-type 'character :fill-pointer 0))
		(vector-push #\SPACE tempVector)
		(setq padTemp (concatenate 'string padTemp tempVector))
	)

	(cond((not right)
		(setq padTemp (concatenate 'string localLineNum padTemp "     "))
	)
	(t	(setq padTemp (concatenate 'string padTemp localLineNum))
	))


)

;Declaration of Variables
(defvar temp)
(defvar tempWord)

(defvar fileName)

(defvar longest)
(defvar shortest)
(defvar currLine)

(defvar lineNum)
(defvar longLineNum)
(defvar shortLineNum)
(defvar longCount)
(defvar shortCount)
(defvar charCount)
(defvar wordCount)

;Initialization of Varaibles
(setq temp #\SPACE)
(setq tempWord "")

(setq lineNum 1)
(setq longLineNum -1)
(setq shortLineNum -1)
(setq longCount -1)
(setq shortCount 61)
(setq charCount 0)
(setq wordCount 0)

;User is prompted for a file name
(princ "Please Enter A File Name: ")

(finish-output)

;Reads in keyboard input
(defvar input)
(setq input (read))

;Print first line number
(write-line "")
(write-string (concatenate 'string (padString (write-to-string lineNum) t) "  "))

;Open the file
(setq fileName (open input))

;The main loop of the program that is responsible for reading in the file
;character by character, reconstituting each word, and stripping each line of
;unwanted characters, as well as determining the longest and shortest line
(loop for temp = (read-char fileName nil :eof)
	until(eq temp :eof)
		;if the character is a space or a tab or a new line and the previous character was
		;not, reconstitute a word
		do(cond((and (or(char= temp #\SPACE) (char= temp #\TAB) (char= temp #\newline)) (string/= tempWord "" ) )
			;If the current amount of characters on the line + the length of the
			;next word is less than 60, concatenate the word to the line
			(cond((< (+ charCount  (length tempWord) ) 60)
				(write-string (concatenate 'string tempWord " "))
				(setq wordCount (+ wordCount 1))
			
				;If this is the first word of the first line, don't add a
				;leading space, otherwise concatenate the word to the current
				;line and reset tempWord	
				(cond((and (= lineNum 1) (= wordCount 1))
					(setq currLine tempWord)
					(setq charCount (length tempWord))
					(setq tempWord "")
				)
				(t	(setq currLine (concatenate 'string currLine " " tempWord))
					(setq charCount (+  charCount (length tempWord) 1 ))
					(setq tempWord "")
				))
			)
			;Otherwise, the current line is complete. Check it against the shortest
			;and longest lines to see if it should replace either of them
			(t	
				;If this is the first line, it is both the longest and shortest line
				(cond((= lineNum 1)
					(setq longest currLine)
					(setq longLineNum lineNum)
					(setq longCount wordCount)
					(setq shortest currLine)
					(setq shortLineNum lineNum)
					(setq shortCount wordCount)
				))

				;Check first to see if the current line is the longest, then if
				;it is tied for longest, then shortest and tied for shortest,
				;breaking ties by character count
				(cond((> wordCount longCount)
					(setq longest currLine)
					(setq longLineNum lineNum)
					(setq longCount wordCount)
				)
				((= wordCount longCount)
					(cond((< charCount (length longest))
						(setq longest currLine)
						(setq longLineNum lineNum)
						(setq longCount wordCount)
					))
				)
				((< wordCount shortCount)
					(setq shortest currLine)
					(setq shortLineNum lineNum)
					(setq shortCount wordCount)
				)
				((= wordCount shortCount)
					(cond((< charCount (length shortest))
						(setq shortest currLine)
						(setq shortLineNum lineNum)
						(setq shortcount wordCount)
					))
				)
				)

				;Increment the line number and print it along with the next word
				;in the sequence. Also reset counters.
				(setq lineNum (+ lineNum 1))
				(write-line "")
				(write-string (concatenate 'string (padString (write-to-string lineNum) t) "  " tempWord " "))
				(setq charCount (length tempWord))
				(setq wordCount 1)
				(setq currLine tempWord)
				(setq tempword "")
			))
		))

	;If none of the above conditions are met and the character is not a space or
	;tab, concatenate it to the current word
	(cond((and (char/= temp #\SPACE) (char/= temp #\TAB) (char/= temp #\newline) (not (digit-char-p temp)))
		
		(setq tempVector (make-array 1 :element-type 'character :fill-pointer 0))
		(vector-push temp tempVector )
		(setq tempWord (concatenate 'string tempWord tempVector))
	))

)

;When read reaches the end of the file, check the last line of input to see if
;it is the longest or shortest line
(cond((> wordCount longCount)
	(setq longest currLine)
        (setq longLineNum lineNum)
        (setq longCount wordCount)
        )
        ((= wordCount longCount)
        	(cond((< charCount (length longest))
                	(setq longest currLine)
                        (setq longLineNum lineNum)
                        (setq longCount wordCount)
                ))
        )
        ((< wordCount shortCount)
        	(setq shortest currLine)
                (setq shortLineNum lineNum)
                (setq shortCount wordCount)
        )
        ((= wordCount shortCount)
        	(cond((< charCount (length shortest))
                	(setq shortest currLine)
                        (setq shortLineNum lineNum)
                        (setq shortcount wordCount)
                ))
        )
)

;Print the longest and shortest lines to the screen
(write-line "")
(write-line "")
(write-string (concatenate 'string "LONG" "   " (padString (write-to-string longLineNum) nil) longest))
(write-line "")
(write-string (concatenate 'string "SHORT" "  " (padString (write-to-string shortLineNum) nil) shortest))
(write-line "")
