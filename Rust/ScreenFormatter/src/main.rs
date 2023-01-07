use std::fs;
use std::io::{stdin,stdout,Write,self};
use std::path::Path;

//Pre-Condition: The current line number for the output is calculated and
//passed in along with a boolean indicating whether the function should
//left or right align
//Post-Condition: The line number is padded to eight characters as either
//a left or right alignment and returned
fn pad_string(mut line_num: String, right: bool) -> String
{
	let padding = 8 - line_num.chars().count();
	let mut temp_str = String::from("");
	
	for index in 0..padding
	{
		temp_str.push(' ');
	}

	if right
	{
		temp_str += &line_num;
		return temp_str;
	}
	else
	{
		line_num += &temp_str;
		line_num += "     ";
		return line_num;
	}
}

fn main() 
{	
	//User is prompted for a file name
	print!("Please Enter A File Name: ");
	io::stdout().flush();

	let mut input = String::new();

	stdin().read_line(&mut input).unwrap();
	input = input.trim().to_string();


	let filename = Path::new(&input);

	//Specified file is read into a string
	let contents = fs::read_to_string(filename)
	.expect("File Not Found! Exiting Program.");

	//Declarationa nd initialization of variables
	let file_vec: Vec<char> = contents.chars().collect();

	let mut temp_char = ' ';
	let mut temp_word = String::from("");

	let mut longest = String::from("");
	let mut shortest = String::from("");
	let mut curr_line = String::from("");

	let mut line_num = 1;
	let mut long_line_num = -1;
	let mut short_line_num = -1;
	let mut long_count = -1;
	let mut short_count = 61;
	let mut char_count = 0;
	let mut word_count = 0;

	//Print first line number
	println!("");
	print!("{}  ", pad_string(line_num.to_string(), true) );

	//The main loop of the program that is responsible for reading in the file
	//character by character, reconstituting each word, and stripping each line of
	//unwanted characters, as well as determining the longest and shortest line
	for index in 0..file_vec.len()
	{
		temp_char = file_vec[index];

		//If the character is a space or a tab and the previous character was
		//niether, reconstitute a word
		if (temp_char == ' ' || temp_char == '\t' || temp_char == '\n') && temp_word != ""
		{
			//If the current amount of characters on the line + the length of the
        		//next word is less than 60, concatenate the word to the line
			if (char_count + temp_word.chars().count()) < 60
			{
				print!("{} ", temp_word);
				word_count = word_count + 1;

				//If this is the first word of the first line, don't add a
                		//leading space, otherwise concatenate the word to the current
                		//line and reset tempWord
				if line_num == 1 && word_count == 1
				{
					curr_line = temp_word.clone();
					char_count = temp_word.chars().count();
					temp_word = "".to_string();
				}
				else
				{
					curr_line.push(' ');
					curr_line += &temp_word;
					char_count = char_count + temp_word.chars().count() + 1;
					temp_word = "".to_string();
				}
			}
			//Otherwise, the current line is complete. Check it against the shortest
        		//and longest lines to see if it should replace either of them
			else
			{
				//If this is the first line, it is both the longest and shortest line
				if line_num == 1
				{
					longest = curr_line.clone();
					long_line_num = line_num;
					long_count = word_count;
					shortest = curr_line.clone();
					short_line_num = line_num;
					short_count = word_count;
				}

				//Check first to see if the current line is the longest, then if
                		//it is tied for longest, then shortest and tied for shortest,
                		//breaking ties by character count
				if word_count > long_count
				{
					longest = curr_line.clone();
					long_line_num = line_num;
					long_count = word_count;
				}
				else if word_count == long_count
				{
					if char_count < longest.chars().count()
					{
						longest = curr_line.clone();
						long_line_num = line_num;
						long_count = word_count;
					}
				}
				else if word_count < short_count
				{
					shortest = curr_line.clone();
					short_line_num = line_num;
					short_count = word_count;
				}
				else if word_count == short_count
				{
					if char_count < shortest.chars().count()
					{
						shortest = curr_line.clone();
						short_line_num = line_num;
						short_count = word_count;
					}
				}

				//Increment the line number and print it along with the next word
                		//in the sequence. Also reset counters.
				line_num = line_num + 1;
				println!();
				print!("{}  {} ", pad_string(line_num.to_string(), true), temp_word);
				char_count = temp_word.chars().count();
				word_count = 1;
				curr_line = temp_word.clone();
				temp_word = "".to_string();	
			}
		}

		//If none of the above conditions are met and the character is not a space or
		//tab or number or new line, concatenate it to the current word
		if temp_char != ' ' && temp_char != '\t' && temp_char != '\n' && !temp_char.is_digit(10)
		{
			temp_word.push(temp_char);
		}
		
	}	

	//When read reaches the end of the file, check the last line of input to see if
	//it is the longest or shortest line
	if word_count > long_count
        {
        	longest = curr_line.clone();
                long_line_num = line_num;
                long_count = word_count;
        }
        else if word_count == long_count
        {
                if char_count < longest.chars().count()
                {
         	       longest = curr_line.clone();
                       long_line_num = line_num;
                       long_count = word_count;
                }
        }
        else if word_count < short_count
        {
        	shortest = curr_line.clone();
                short_line_num = line_num;
                short_count = word_count;
        }
        else if word_count == short_count
        {
                if char_count < shortest.chars().count()
                {
                	shortest = curr_line.clone();
                        short_line_num = line_num;
                        short_count = word_count;
                }
        }

	//Print the longest and shortest lines to the screen
	println!();
	println!();
	println!("LONG   {}{}", pad_string(long_line_num.to_string(), false), longest);
	println!("SHORT  {}{}", pad_string(short_line_num.to_string(), false), shortest);

}
