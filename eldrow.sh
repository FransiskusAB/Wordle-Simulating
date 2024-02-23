#!/bin/bash
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`

echo -e "\e[32m _____ _     ____  ____   _____        __"
echo -e "\e[33m| ____| |   |  _ \|  _ \ / _ \ \      / /"
echo -e "\e[31m|  _| | |   | | | | |_) | | | \ \ /\ / / "
echo -e "\e[32m| |___| |___| |_| |  _ <| |_| |\ V  V /  "
echo -e "\e[33m|_____|_____|____/|_| \_\\___/  \_/\_/   "
echo -e "\e[31m${bold}${underline}A GAME NOT DISSIMILAR TO WORDLE${nounderline}${nobold}"
echo -e "\e[0m"

guess_counter=1

function show_colour_legend()
{
echo "Input a valid 5-letter word to guess our randomly chosen word, with the following clue"
echo -e "\e[1;30;1;42mLetter is: in the correct spot\e[0m"
echo -e "\e[1;30;1;43mLetter is:   in the wrong spot\e[0m"
echo -e "\e[1;30;1;41mLetter is:     not in any spot\e[0m"
echo "Please wait while we are loading and choosing the words ......"
}

function play_again_option()
{
echo "Would you like to play again? (Y/N)"
read choice
case $choice in
Y|y)
	guess_counter=1
	choose_answer
	retrieve_answer
;;
N|n)
	rm temp_answer_bank && exit 0
;;
*)
	echo "Please input valid response"
	main_console
esac
}

function create_answer_bank()
{
true > temp_answer_bank # Emptying the file if it exist
touch temp_answer_bank
while IFS= read -r word
do
letter_count=$(echo "$word" | tr -cd '[:alpha:]' | wc -m)
	if [ $letter_count == 5 ]
	then echo "$word" >> temp_answer_bank
	fi
done < wordle-words.txt
# This is where to change the input dictionary or wordlist
# Currently the source is: https://gist.github.com/prichey/95db6bdef37482ba3f6eb7b4dec99101#file-wordle-words-txt
# The document is a list of 5-letter words allowed for wordle
# Theoretically, this code is sieve out words that does not have 5 letter exactly if a full dictionary is loaded
# The Objective is that this code can be reused and recycled for any languages if the dictionary input is changed
}

function choose_answer
{
bank_count=$(cat temp_answer_bank | wc -l)
random_order=$((RANDOM % $bank_count))
target_answer=$(cat temp_answer_bank | head -n $random_order | tail -n 1 | tr '[:lower:]' '[:upper:]')
}

function check_and_display()
{
input_first=${input_answer:0:1}
input_second=${input_answer:1:1}
input_third=${input_answer:2:1}
input_fourth=${input_answer:3:1}
input_fifth=${input_answer:4:1}

target_first=${target_answer:0:1}
target_second=${target_answer:1:1}
target_third=${target_answer:2:1}
target_fourth=${target_answer:3:1}
target_fifth=${target_answer:4:1}

if [ $input_first == $target_first ]
then
	display_first="\e[1;30;1;42m$input_first\e[0m"
elif [ $input_first == $target_second ] || [ $input_first == $target_third ] || [ $input_first == $target_fourth ] || [ $input_first == $target_fifth ]
then
	display_first="\e[1;30;1;43m$input_first\e[0m"
else
display_first="\e[1;30;1;41m$input_first\e[0m"
fi

if [ $input_second == $target_second ]
then
	display_second="\e[1;30;1;42m$input_second\e[0m"
elif [ $input_second == $target_first ] || [ $input_second == $target_third ] || [ $input_second == $target_fourth ] || [ $input_second == $target_fifth ]
then
	display_second="\e[1;30;1;43m$input_second\e[0m"
else
	display_second="\e[1;30;1;41m$input_second\e[0m"
fi

if [ $input_third == $target_third ]
then
	display_third="\e[1;30;1;42m$input_third\e[0m"
elif [ $input_third == $target_second ] || [ $input_third == $target_first ] || [ $input_third == $target_fourth ] || [ $input_third == $target_fifth ]
then
	display_third="\e[1;30;1;43m$input_third\e[0m"
else
	display_third="\e[1;30;1;41m$input_third\e[0m"
fi

if [ $input_fourth == $target_fourth ]
then
	display_fourth="\e[1;30;1;42m$input_fourth\e[0m"
elif [ $input_fourth == $target_second ] || [ $input_fourth == $target_first ] || [ $input_fourth == $target_third ] || [ $input_fourth == $target_fifth ]
then
	display_fourth="\e[1;30;1;43m$input_fourth\e[0m"
else	
	display_fourth="\e[1;30;1;41m$input_fourth\e[0m"
fi

if [ $input_fifth == $target_fifth ]
then
	display_fifth="\e[1;30;1;42m$input_fifth\e[0m"
elif [ $input_fifth == $target_second ] || [ $input_fifth == $target_first ] || [ $input_fifth == $target_third ] || [ $input_fifth == $target_fourth ]
then
	display_fifth="\e[1;30;1;43m$input_fifth\e[0m"
else	
	display_fifth="\e[1;30;1;41m$input_fifth\e[0m"
fi

# Function to put all the indivually checked number on one line
combined_display="$display_first$display_second$display_third$display_fourth$display_fifth"
echo -e "$combined_display"
}

function retrieve_answer()
{
echo ""
echo "Guess Number: $guess_counter/6"
read -p "Please enter your guess:  " raw_input_answer
input_answer=$(echo $raw_input_answer | tr '[:lower:]' '[:upper:]')

check_only_five
check_valid_word
check_and_display

if [ $target_answer == $input_answer ]
then
	echo "CORRECT! The Answer is: $target_answer"
	echo ""
	play_again_option
else
	let "guess_counter=guess_counter+1"
	if [ $guess_counter -gt 6 ]
		then
			echo ""
			echo "You are running out of guessing opportunity!"
			echo "The Answer is: $target_answer"
			play_again_option
		else
		echo "INCORRECT! Please Try Again"
		retrieve_answer
		retrieve_answer
	fi
fi
}

function check_valid_word()
{
word_match=$(cat temp_answer_bank | grep -i $input_answer | wc -l)
if [ $word_match == 0 ]
then
	echo "WORD INVALID"
	echo "${underline}Please only enter 5-letter valid words as guesses!${nounderline}"
	retrieve_answer
fi
}

function check_only_five()
{
guess_length=$(echo $input_answer | wc -m)
if [ $guess_length != 6 ] # 6 is used instead of 5 because of the default new character line
then
	echo "WORD IS NOT 5-LETTERED"
	echo "${underline}Please only enter 5-letter valid words as guesses!${nounderline}"
	retrieve_answer
fi
}

# Calling the functions
show_colour_legend
create_answer_bank # This function is not called if a list of 5-lettered word are used instead of a full dictionary
choose_answer
retrieve_answer
