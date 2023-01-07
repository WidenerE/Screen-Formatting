        IDENTIFICATION DIVISION.
        PROGRAM-ID. ScreenReader.

        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.
                SELECT InputFile ASSIGN TO DYNAMIC WS-FileName
                        ORGANIZATION IS SEQUENTIAL.

        DATA DIVISION.
        FILE SECTION.
        FD InputFile.
        01 InputFileTxt.
                05 temp PIC A(1).

        WORKING-STORAGE SECTION.
        01 WS-Temp PIC A(1).
        01 WS-EOF PIC 9(1).

        01 WS-FileName PIC x(30).

        01 WS-TempWord PIC A(60) VALUE " ".
        01 WS-Longest PIC A(60) VALUE " ".
        01 WS-Shortest PIC A(60) VALUE " ".
        01 WS-CurrLine PIC A(60) VALUE " ".
        01 WS-Concate PIC A(60) VALUE " ".

        01 WS-LineNum PIC 9(8) VALUE 1.
        01 WS-LongLineNum PIC 9(8) VALUE 1.
        01 WS-ShortLineNum PIC 9(8) VALUE 0.
        01 WS-LongCount PIC S9(8) VALUE -1.
        01 WS-ShortCount PIC 9(8) VALUE 61.
        01 WS-CharCount PIC 9(8) VALUE 0.
        01 WS-WordCount PIC 9(8) VALUE 0.

        PROCEDURE DIVISION.

      /  Prompts the user for a file name and stores the result from the
      /  keyboard  
        DISPLAY "Please Enter A File Name: " WITH NO ADVANCING
        ACCEPT WS-FileName
        DISPLAY ""
      /Print first line number  
        DISPLAY FUNCTION TRIM(WS-LineNum, LEADING)
      - WITH NO ADVANCING
        DISPLAY SPACE WITH NO ADVANCING
        DISPLAY SPACE WITH NO ADVANCING
      /Open Specified File
        OPEN INPUT InputFile.
      /The main loop of the program that is responsible for reading in
      /the file
      / character by character, reconstituting each word, and stripping
      / each line of
      / unwanted characters, as well as determining 
      /  the longest and shortest line
          PERFORM UNTIL WS-EOF = 1
            READ InputFile NEXT RECORD INTO WS-Temp
              AT END MOVE 1 TO WS-EOF
              NOT AT END
      /Outer IF
      /if the character is a space or a tab or a linefeed
      /and the previous character
      /was niether, reconstitute a word
                IF (WS-Temp IS = SPACE OR WS-Temp = X"0A" OR WS-Temp =
      -          X"09")
      -           AND WS-TempWord IS NOT =" " THEN
      /Inner IF
      /If the current amount of characters on the line + the length of
      /the
      /!next word is less than 60, concatenate the word to the line
                  IF WS-CharCount + FUNCTION LENGTH(FUNCTION TRIM
      -           (WS-TempWord))<60 Then
      
                    DISPLAY FUNCTION TRIM(WS-TempWord) WITH NO ADVANCING
                    DISPLAY SPACE WITH NO ADVANCING
                    ADD 1 TO WS-WordCount
       
      /If this is the first word of the first line, don't add a
      /leading space, otherwise concatenate the word to the
      /current
      /line and reset tempWord             
                    IF WS-LineNum IS = 1 AND WS-WordCount IS = 1 THEN
                      MOVE WS-TempWord TO WS-CurrLine
                      ADD FUNCTION LENGTH(FUNCTION TRIM(WS-TempWord))
      -               TO WS-CharCount
                      MOVE " " TO WS-TempWord
                    ELSE
                        STRING WS-CurrLine DELIMITED BY X"0A"
                       SPACE DELIMITED BY SIZE
                       INTO WS-Concate
                     END-STRING

                     STRING WS-Concate DELIMITED BY SPACE
                       WS-TempWord DELIMITED BY SIZE 
                       INTO WS-CurrLine
                     END-STRING
      
                     MOVE "" TO WS-Concate                    
 
                    ADD FUNCTION LENGTH(FUNCTION TRIM(WS-TempWord))
      -             1 TO WS-CharCount
                    MOVE " " TO WS-TempWord
                  END-IF             
      /Inner Else
      /Otherwise, the current line is complete. Check it against the
      /shortest
      /and longest lines to see if it should replace either of them
                 ELSE

      /If this is the first line, it is both the longest and shortest
      /line
                   IF WS-LineNum IS = 1 THEN
                     MOVE WS-CurrLine TO WS-Longest
                     MOVE WS-LineNum TO WS-LongLineNum
                     MOVE WS-WordCount TO WS-LongCount
                     MOVE WS-CurrLine TO WS-Shortest
                     MOVE WS-LineNum TO WS-ShortLineNum
                     MOVE WS-WordCount TO Ws-ShortCount
                   END-IF

      /Check first to see if the current line is the longest, then if
      /it is tied for longest, then shortest and tied for shortest,
      /breaking ties by character count
                   IF WS-WordCount > WS-LongCount THEN
                        MOVE WS-CurrLine TO WS-Longest
                        MOVE WS-LineNum TO WS-LongLineNum
                        MOVE WS-WordCount TO WS-LongCount
                   ELSE 
                      IF WS-WordCount IS = WS-LongCount THEN
                        IF WS-CharCount < FUNCTION LENGTH(WS-Longest)
      -                 THEN
                                MOVE WS-CurrLine TO WS-Longest
                                MOVE WS-LineNum TO WS-LongLineNum
                                MOVE WS-WordCount TO WS-LongCount
                        END-IF
                      END-IF
                      IF WS-WordCount < WS-ShortCount THEN
                        MOVE WS-CurrLine TO WS-Shortest
                        MOVE WS-LineNum TO WS-ShortLineNum
                        MOVE WS-WordCount TO WS-ShortCount
                      END-IF

                      IF WS-WordCount IS  = WS-ShortCount THEN
                        IF WS-CharCount < FUNCTION LENGTH(WS-Shortest)
      -                  THEN
                                MOVE WS-CurrLine TO WS-SHortest
                                MOVE WS-LineNum TO WS-ShortLineNum
                                MOVE WS-WordCount TO WS-ShortCount
                        END-IF
                      END-IF
                    END-IF             
      
      /Increment the line number and print it along with the next word
      /in the sequence. Also reset counters.
                   ADD 1 TO WS-LineNum
                   DISPLAY SPACE
                   DISPLAY FUNCTION TRIM(WS-LineNum)
      -            WITH NO ADVANCING
                   DISPLAY SPACE WITH NO ADVANCING
                   DISPLAY SPACE WITH NO ADVANCING
                   DISPLAY FUNCTION TRIM(WS-TempWord) WITH NO ADVANCING
                   DISPLAY SPACE WITH NO ADVANCING
                   MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-TempWord))
      -            TO  WS-CharCount
                   MOVE 1 TO WS-WordCount
                   MOVE WS-TempWord TO WS-CurrLine
                   MOVE " " TO WS-TempWord
                   
      /End Inner
                END-IF
              END-IF  
                
      /!If none of the above conditions are met and the character is not
      /  a space or tab, concatenate it to the current word         
               IF WS-TEMP NOT NUMERIC AND WS-TEMP NOT = X"0A" AND
                WS-Temp NOT = X"09" THEN
                
                 STRING WS-TempWord DELIMITED BY SPACE
                   WS-Temp DELIMITED BY SIZE
                   INTO WS-Concate
                 END-STRING
                 MOVE WS-Concate TO WS-TempWord
                 MOVE " " TO WS-Concate              
      /End Outer 
               END-IF                 
                                
                                
                               
             END-READ
           END-PERFORM

      /!When read reaches the end of the file, check the last line of
      /input to see if it is the longest or shortest line
        IF WS-WordCount > WS-LongCount THEN
                        MOVE WS-CurrLine TO WS-Longest
                        MOVE WS-LineNum TO WS-LongLineNum
                        MOVE WS-WordCount TO WS-LongCount
                   ELSE
                      IF WS-WordCount = WS-LongCount THEN
                        IF WS-CharCount < FUNCTION LENGTH(WS-Longest)
      -                 THEN
                                MOVE WS-CurrLine TO WS-Longest
                                MOVE WS-LineNum TO WS-LongLineNum
                                MOVE WS-WordCount TO WS-LongCount
                        END-IF
                      END-IF
                      IF WS-WordCount < WS-ShortCount THEN
                        MOVE WS-CurrLine TO WS-Shortest
                        MOVE WS-LineNum TO WS-ShortLineNum
                        MOVE WS-WordCount TO WS-ShortCount
                      END-IF

                      IF WS-WordCount = WS-ShortCount THEN
                        IF WS-CharCount < FUNCTION LENGTH(WS-Shortest)
      -                  THEN
                                MOVE WS-CurrLine TO WS-SHortest
                                MOVE WS-LineNum TO WS-ShortLineNum
                                MOVE WS-WordCount TO WS-ShortCount
                        END-IF
                      END-IF
                   END-IF


      /!Print the longest and shortest lines to the screen
        DISPLAY SPACE
        DISPLAY SPACE
        DISPLAY "LONG" WITH NO ADVANCING
        DISPLAY "   "  WITH NO ADVANCING
        DISPLAY WS-LongLineNum WITH NO ADVANCING
        DISPLAY "     " WITH NO ADVANCING
        DISPLAY WS-Longest
        DISPLAY "SHORT" WITH NO ADVANCING
        DISPLAY "  " WITH NO ADVANCING
        DISPLAY WS-ShortLineNum WITH NO ADVANCING
        DISPLAY "     " WITH NO ADVANCING
        DISPLAY WS-Shortest
        
        CLOSE InputFile
        STOP RUN.
                
