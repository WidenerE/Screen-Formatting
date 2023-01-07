with Ada.Text_IO;
use Ada.Text_IO;
with Ada.IO_Exceptions;
use Ada.IO_Exceptions;
with Ada.Strings.Unbounded; 
use Ada.Strings.Unbounded;
with Ada.Strings;
use Ada.Strings;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams; 
use Ada.Text_IO.Text_Streams;
with Ada.Characters.Latin_1;
use Ada.Characters.Latin_1;

procedure screenformat is

	--Pre-Condition: A string is passed in after being stripped from the
        --input file
        --Post-Condition: True or False is returned depending on if the string
        --is a number or not
	function isNum (temp : String) return Boolean is

        begin

        if temp = "0" or temp = "1" or temp = "2" or temp = "3" or temp = "4" or temp = "5" or temp = "6" or temp = "7" or temp = "8" or temp = "9" then
                return True;
        else
                return False;
        end if;

        end isNum;

	--Pre-Condition: The current line number for the output is calculated and
        --passed in along with a boolean indicating whether the function should
        --left or right align
        --Post-Condition: The line number is padded to eight characters as either
        --a left or right alignment and returned
	function padString(lineNum : Unbounded_String; right : Boolean) return Unbounded_String is
	
	padding : Integer;
	temp : Unbounded_String;

	begin

	padding := 7 - Length(lineNum);
	temp := To_Unbounded_String("");

	for i in 0..padding loop
		temp := temp & " ";
	end loop;

	if right then
		return temp & lineNum;
	else
		return lineNum & temp & "     "; 
	end if;


	end padString;

--Declaration of variables
	InputFile : Ada.Text_IO.File_Type;
	InStream : Stream_Access;

	temp : String := " ";
	tempWord : Unbounded_String;
	fileName : String(1..1000);
--Variables that hold various lines of text
	longest : Unbounded_String;
	shortest : Unbounded_String;
	currLine : Unbounded_String;

--Counters and line numbers
	lineNum, longLineNum, shortLineNum, longCount, shortCount, charCount, wordCount, test: Integer;

begin

--Initialization of variables
	tempWord := To_Unbounded_String("");

	lineNum := 1;
	longLineNum := -1;
	shortLineNum := -1;
	longCount := -1;
	shortCount := 61;
	charCount := 0;
	wordCount := 0;

--User is prompted for a file name and name is read into a variable
	Ada.Text_IO.Put("Please Enter A File Name: ");
	Get_Line(fileName,test);
	Put_Line("");

--Specified file is opened	
begin
	Open(InputFile, In_File, fileName);
exception
	when E : Ada.IO_Exceptions.Name_Error =>
			    Put_Line("File Not Found! Exiting Program.");
	raise;
end;

	--Print first line number
	Ada.Text_IO.Put(To_String(padString(To_Unbounded_String(Integer'Image(lineNum)), TRUE)) & "  ");

	InStream := Stream(Inputfile);

	--The main loop of the program that is responsible for reading in the file
	--character by character, reconstituting each word, and stripping each line of
	--unwanted characters, as well as determining the longest and shortest line
	while not Ada.Text_IO.End_Of_File(InputFile) loop
		String'Read(InStream, temp);
		if temp(temp'First) = LF then
			temp := " ";
		end if;
		
		--if the character is a space or a tab and the previous character was
		--niether, reconstitute a word
		if (temp = " " or temp(temp'First)  = HT) and tempWord /= "" then
			--If the current amount of characters on the line + the length of the
        		--next word is less than 60, concatenate the word to the line
			if(charCount + Length(tempWord) < 60) then
				Ada.Text_IO.Put(To_String(tempWord) & " ");
				wordCount := wordCount + 1;
				
				--If this is the first word of the first line, don't add a
                		--leading space, otherwise concatenate the word to the current
                		--line and reset tempWord
				if lineNum = 1 and wordCount = 1 then
					currLine := tempWord;
					charCount := Length(tempWord);
					tempWord := To_Unbounded_String("");
				else
					currLine := currLine & " " & tempWord;
					charCount := charCount + Length(tempWord) + 1;
					tempWord := To_Unbounded_String("");
				end if;
			--Otherwise, the current line is complete. Check it against the shortest
        		--and longest lines to see if it should replace either of them
			else
				--If this is the first line, it is both the longest and shortest
                		--line
				if lineNum = 1 then
					longest := currLine;
					longLineNum := lineNum;
					longCount := wordCount;
					shortest := currLine;
					shortLineNum := lineNum;
					shortCount := wordCount;
				end if;

				--Check first to see if the current line is the longest, then if
                		--it is tied for longest, then shortest and tied for shortest,
                		--breaking ties by character count
				if wordCount > longCount then
					longest := currLine;
					longLineNum := lineNum;
					longCount := wordCount;
				elsif wordCount = longCount then
					if charCount < Length(longest) then
						longest := currLine;
						longLineNum := lineNum;
						longCount := wordCount;
					end if;
				elsif wordCount < shortCount then
					shortest := currLine;
					shortLineNum := lineNum;
					shortCount := wordCount;
				elsif wordCount = shortCount then
					if charCount < Length(shortest) then
						shortest := currLine;
						shortLineNum := lineNum;
						shortCount := wordCount;
					end if;
				end if;

				--Increment the line number and print it along with the next word
                		--in the sequence. Also reset counters.
				lineNum := lineNum + 1;
				Put_Line("");
				Ada.Text_Io.Put(To_String(padString(To_Unbounded_String(Integer'Image(lineNum)), TRUE)) & "  " & To_String(tempWord) & " ");
				charCount := Length(tempWord);
				wordCount := 1;
				currLine := tempWord;
				tempWord := To_Unbounded_String("");
				
			end if;
		end if;

	--If none of the above conditions are met and the character is not a space or
	--tab or number, concatenate it to the current word
	if temp /= " " and temp(temp'First) /= HT and not isNum(temp) then
		tempWord := tempWord & To_Unbounded_String(temp);
	
	end if;


	end loop;


	--When read reaches the end of the file, check the last line of input to see if
	--it is the longest or shortest line
	if wordCount > longCount then
		longest := currLine;
                longLineNum := lineNum;
                longCount := wordCount;
        elsif wordCount = longCount then
                if charCount < Length(longest) then
	                longest := currLine;
                        longLineNum := lineNum;
                        longCount := wordCount;
                end if;
        elsif wordCount < shortCount then
                shortest := currLine;
                shortLineNum := lineNum;
                shortCount := wordCount;
        elsif wordCount = shortCount then
                if charCount < Length(shortest) then
   	             shortest := currLine;
                     shortLineNum := lineNum;
                     shortCount := wordCount;
                end if;
        end if;

	--Print the longest and shortest lines to the screen
	Put_Line("");
	Put_Line("");
	Put_Line("LONG" & "  " & To_String(padString(To_Unbounded_String(Integer'Image(longLineNum)), FALSE)) & " " &  To_String(longest));
	Put_Line("SHORT" & " " & To_String(padString(To_Unbounded_String(Integer'Image(shortLineNum)), FALSE)) & " " & To_String(shortest));


end screenformat;

