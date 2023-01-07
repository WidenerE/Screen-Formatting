#!/usr/bin/julia

#Pre-Condition: The current line number for the output is calculated and
#passed in along with a boolean indicating whether the function should
#left or right align
#Post-Condition: The line number is padded to eight characters as either
#a left or right alignment and returned
function padString(lineNum, right)

        padding = 8 - length(lineNum)
        temp = ""

        for i in 1:padding
                temp = temp * " "
        end

        if(right)
                return temp * lineNum
        else
                return lineNum * temp * "     "
        end
end

#Declaration of variables
temp = ""
tempWord = ""

currLine = ""
longest = ""
shortest = ""

lineNum = 1
longLineNum = -1
shortLineNum = -1
longcount = -1
shortCount = 61
charCount = 0
wordCount = 0

#User is prompted for a file name and the input is stored in a variable
print("Please Enter A File Name: ")
fileName = readline()
println()

#Open the specified file
try
	open(fileName) do file
	#Print the first line number
	print(padString(string(lineNum), true) * "  ")	

	#The main loop of the program that is responsible for reading in the file
	#character by character, reconstituting each word, and stripping each line of
	#unwanted characters, as well as determining the longest and shortest line
	while ! eof(file)

	global temp
	global tempWord

	global currLine
	global longest
	global shortest

	global charCount
	global lineNum
	global longLineNum
	global shortLineNum
	global longCount
	global shortCount
	global wordCount

		#Read in a char from file
		temp = read(file, Char)

		#If the char is a new line, convert it to a space
		if(first(temp) == '\n')
			temp = " "
		end

		#If the character is a space or a tab and the previous character was
		#niether, reconstitute a word
		if((first(temp) == ' ' || first(temp) == '\t') && length(tempWord) != 0)

			#If the current amount of characters on the line + the length of the
			#next word is less than 60, concatenate the word to the line
			if(charCount + length(tempWord) < 60)
			
				print(tempWord * " ")
				wordCount = wordCount + 1

				#If this is the first word of the first line, don't add a
				#leading space, otherwise concatenate the word to the current
				#line and reset tempWord
				if(lineNum == 1 && wordCount == 1)
					currLine = tempWord
					charCount = length(tempWord)
					tempWord = ""
				else
					currLine = currLine * " " * tempWord
					charCount = charCount + length(tempWord) + 1
					tempWord = ""
				end

			#Otherwise, the current line is complete. Check it against the shortest
			#and longest lines to see if it should replace either of them
			else

				#If this is the first line, it is both the longest and shortest line				
				if(lineNum == 1)

					longest = currLine
					longLineNum = lineNum
					longCount = wordCount
					shortest = currLine
					shortLineNum = lineNum
					shortCount = wordCount

				end

				#Check first to see if the current line is the longest, then if
				#it is tied for longest, then shortest and tied for shortest,
				#breaking ties by character count
				if(wordCount > longCount)

					longest = currLine
					longLineNum = lineNum
					longCount = wordCount

				elseif(wordCount == longCount)
	
					if(charCount < length(longest))

						longest = currLine
						longLineNum = lineNum
						longCount = wordCount

					end
				elseif(wordCount < shortCount)

					shortest = currLine
					shortLineNum = lineNum
					shortCount = wordCount

				elseif(wordCount == shortCount)

					if(charCount < length(shortest))

						shortest = currLine
						shortLineNum = lineNum
						shortCount = wordCount

					end					

				end

				#Increment the line number and print it along with the next word
				#in the sequence. Also reset counters.
				lineNum = lineNum + 1
				println()
				print(padString(string(lineNum), true) * "  " * tempWord * " ")
				charCount = length(tempWord)
				wordCount = 1
				currLine = tempWord
				tempWord = ""				

			end

		end

		#If none of the above conditions are met and the character is not a space or
		#tab, concatenate it to the current word
		if(first(temp) != ' ' && first(temp) != '\t' && !isdigit(first(temp)))
			tempWord = tempWord * temp
		end

	end

	global currLine
        global longest
        global shortest

        global charCount
        global lineNum
        global longLineNum
        global shortLineNum
        global longCount
        global shortCount
        global wordCount

	#When read reaches the end of the file, check the last line of input to see if
	#it is the longest or shortest line
	if(wordCount > longCount)

        	longest = currLine
                longLineNum = lineNum
                longCount = wordCount

        elseif(wordCount == longCount)

                if(charCount < length(longest))

                	longest = currLine
                        longLineNum = lineNum
                        longCount = wordCount

                end
        elseif(wordCount < shortCount)

                shortest = currLine
                shortLineNum = lineNum
                shortCount = wordCount

        elseif(wordCount == shortCount)

                if(charCount < length(shortest))

                	shortest = currLine
                        shortLineNum = lineNum
                        shortCount = wordCount

                end

        end

	#!Print the longest and shortest lines to the screen
	println("\n")
	println("LONG" * "   " * padString(string(longLineNum), false)  * longest)
	println("SHORT" * "  " * padString(string(shortLineNum), false) * shortest)

end
	
catch
        println("File Not Found! Exiting Program")
        return
end




