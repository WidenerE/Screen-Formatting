The goal of this exercise was to read in text from a file and format it to the screen, removing unwanted characters such as numbers and tabs.

The algorithm works by prompting the user for a file name, opening the specified file, and then reading it in character by character.
The main loop of the program considers each character individually, throwing out undesireable ones and concatenating valid ones back into words,
which are then printed to the screen. After every line, the program checks that line against the stored longest and shortest lines
to determine if the new line should replace either of them. This process continues until the end of the file. At this point, the longest and shortest lines, as well as the line number they can be found on, are printed to the screen.


Compilation and Running Instructions:
Ada:
Compile: gnatmake ScreenFormat.adb
Run: ScreenFormat
Fortran:
Compile: gfortran ScreenFormat.f95
Run: ./a.out
Cobol:
Compile: cobc -x ScreenFormat.cob
Run: ./ScreenFormat
Julia:
Make executable: chmod u+x ScreenReader.jl
Compile and Run: ScreenReader.jl
Lisp:
Make Executable: chmod u+x ScreenFormatter.lisp
Compile and Run: ScreenFormatter.lisp
NOTE: For Lisp, the file name must be entered surrounded by double quotes.
For example: "ExampleFileName"
Rust:
Concatenate: cat main.rs
Compile and Run: cargo run ScreenFormatter
