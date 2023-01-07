!This module contains a couple of utility functions that help format the input
module utility
IMPLICIT NONE

contains
        !Pre-Condition: A character is passed in after being stripped from the
        !input file
        !Post-Condition: True or False is returned depending on if the character
        !is a number or not
        function isNum(temp) RESULT (outcome)
        IMPLICIT NONE

        character, intent(in) :: temp

        logical :: outcome
        outcome = .FALSE.

        if(temp == '0' .OR. temp == '1' .OR. temp == '2' .OR. temp == '3' .OR. temp == '4' .OR. temp == '5' .OR. temp == '6' &
        .OR. temp == '7' .OR. temp == '8' .OR. temp == '9') then
                outcome = .TRUE.

        end if

        end function isNum

        !Pre-Condition: The current line number for the output is calculated and
        !passed in along with a boolean indicating whether the function should
        !left or right align
        !Post-Condition: The line number is padded to eight characters as either
        !a left or right alignment and returned
        function padString(lineNum, right) RESULT(temp)
        IMPLICIT NONE

        character (*), intent(in) :: lineNum
        logical, intent(in) :: right

        integer :: padding, i
        character(Len = :), allocatable :: temp
      
        !padding is the number of spaces to add to the line number and is
        !calculated by subtracting the length of the line number from 7
        padding = 7 - LEN_TRIM(lineNum)
        temp = ""

        !This loop concatenates the appropriate amount of blank spaces based on
        !padding
        do i = 0, padding
                temp = temp // " "
        end do

        !Determines whether or not to left or right align
        if(right) then
                temp = temp // TRIM(lineNum)
        else 
                temp = TRIM(lineNum) // temp // "     "
        end if

        end function padString


end module utility



!Main Program
program ScreenFormat
use utility
IMPLICIT NONE

!Holds an IOSTAT value that determines if the specified file can be found or not
integer :: stat

!temp stores each character from the input file as they are stripped off and is
!used to reconstruct each word
character(LEN = :), allocatable :: temp
!tempWord stores each reconstituted word
character(LEN = :), allocatable :: tempWord
!intConvert temporarily holds any integers that need to be converted to
!characters
character(LEN = 1000) :: intConvert
!fileName stores the file name specified by the user
character(Len = 1000) :: fileName

!Each of these stores a line of the input file, the longest, shortest, and
!current line respectively
character(LEN = :), allocatable :: longest
character(LEN = :), allocatable :: shortest
character(LEN = :), allocatable :: currLine

!These integers either store various line numbers or are used as counters to
!determine how many words or characters are in a line
integer :: lineNum, longLineNum, shortLineNum, longCount, shortCount, charCount, wordCount

!Default initialization of variables
temp = ' '
tempWord = ''

lineNum = 1
longLineNum = -1
shortlineNum = -1
longCount = -1
shortCount = 61
charCount = 0
wordCount = 0

!Prompts the user for a file name and stores the result from the keyboard
write( *, "(*(g0))", advance='no') 'Please Enter A File Name: '
read *, fileName
print *, ""

!Opens the file
open(unit = 9, IOSTAT = stat, status = 'OLD', file = fileName)
!If the file does not exist, exit the program
if(stat /= 0) then 
        write(*, "(*(g0))") "File Not Found! Exiting Program."
        stop 1
end if

!Converts linNum to a string and prints the current line number to the screen
write(intConvert, '(I0)') lineNum
write(*, "(g0)", advance = 'no') padString(intConvert, .TRUE.) // " " // " "

!The main loop of the program that is responsible for reading in the file
!character by character, reconstituting each word, and stripping each line of
!unwanted characters, as well as determining the longest and shortest line
do
read(9,'(A)', advance = 'no', EOR = 9998, END = 9999) temp

!When read reachs the end of a record, check if the character is a number
!if so, continue to the next loop iteration
9998 if(isNum(temp)) then
        cycle
!Otherwise, if the character is a space or a tab and the previous character was
!niether, reconstitute a word
elseif((temp == " " .OR. temp == char(9)) .AND. tempWord /= '') then
        !If the current amount of characters on the line + the length of the
        !next word is less than 60, concatenate the word to the line
        if(charCount + LEN(tempWord) < 60) then
                write(*, "(g0)", advance = 'no') tempWord // ' '
                !Increment the word counter for this line
                wordCount = wordCount + 1

                !If this is the first word of the first line, don't add a
                !leading space, otherwise concatenate the word to the current
                !line and reset tempWord
                if(lineNum == 1 .AND. wordCount == 1) then
                        currLine = tempWord
                        charCount = LEN(tempWord)
                        tempWord = ''
                else 
                        currLine = currLine // " " // tempWord
                        charCount = charCount + LEN(tempWord) + 1
                        tempWord = ''
                end if
        !Otherwise, the current line is complete. Check it against the shortest
        !and longest lines to see if it should replace either of them
        else
                !If this is the first line, it is both the longest and shortest
                !line
                if(lineNum == 1) then
                        longest = currLine
                        longLineNum = lineNum
                        longCount = wordCount 
                        shortest = currLine 
                        shortLineNum = lineNum
                        shortCount = wordCount
                end if

                !Check first to see if the current line is the longest, then if
                !it is tied for longest, then shortest and tied for shortest,
                !breaking ties by character count
                if(wordCount > longCount) then
                        longest = currLine
                        longLineNum = lineNum
                        longCount = wordCount
                else if(wordCount == longCount) then
                        if(charCount < LEN(longest)) then
                                longest = currLine
                                longLineNum = lineNum
                                longCount = wordCount
                        end if        
                else if(wordCount < shortCount) then
                        shortest = currLine
                        shortLineNum = lineNum
                        shortCount = wordCount 
                else if(wordCount == shortCount) then
                        if(charCount < LEN(shortest)) then
                                shortest = currLine
                                shortLineNum = lineNum
                                shortCount = wordCount
                        end if
                end if
        
                !Increment the line number and print it along with the next word
                !in the sequence. Also reset counters.
                lineNum = lineNum + 1
                print *, ""
                write(intConvert, '(I0)') lineNum
                write(*, "(g0)", advance = 'no') padString(intConvert, .TRUE.) // ' ' // ' ' // tempWord // ' '
                charCount = LEN(tempWord)
                wordCount = 1
                currLine = tempWord 
                tempWord = ''

        end if
end if

!If none of the above conditions are met and the character is not a space or
!tab, concatenate it to the current word
if(temp /= ' ' .AND. temp /= CHAR(9)) then
        tempWord = tempWord // temp
end if

end do

!When read reaches the end of the file, check the last line of input to see if
!it is the longest or shortest line
9999 if(wordCount > longCount) then
        longest = currLine
        longLineNum = lineNum
        longCount = wordCount
else if(wordCount == longCount) then
        if(charCount < LEN(longest)) then
                longest = currLine
                longLineNum = lineNum
                longCount = wordCount
        end if
else if(wordCount < shortCount) then
        shortest = currLine
        shortLineNum = lineNum
        shortCount = wordCount
else if(wordCount == shortCount) then
        if(charCount < LEN(shortest)) then
                shortest = currLine
                shortLineNum = lineNum
                shortCount = wordCount
        end if
end if

!Print the longest and shortest lines to the screen
print *, ""
print *, ""
write(intConvert, '(I0)') longLineNum
write(*, "(g0)", advance = 'no' ) "LONG" // "   " // padString(intConvert, .FALSE.) // longest
write(intConvert, '(I0)') shortLineNum
print *, ""
write(*, "(g0)", advance = 'no') "SHORT" // "  " // padString(intConvert, .FALSE.) // shortest
print *, ""
        
!Close the file
close(9)

end program ScreenFormat
