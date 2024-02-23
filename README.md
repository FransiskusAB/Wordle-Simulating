# Wordle-Simulating
This is a bash script that simulates wordle

Features:
Shows red if the letter is not in the secret word
Shows yellow if the letter is in the secret word but in the wrong position
Restriction to input non-valid words
Restriction to input words longer or shorter than 5 letters
Count the number of tries and stop after 6

The list of words is from : https://gist.github.com/prichey/95db6bdef37482ba3f6eb7b4dec99101#file-wordle-words-txt

Initially the effort was to be able to take a full dictionary in any language or any version and filter for 5 words to create an answer bank
However, this is abandoned because:
1. There is no satisfactory list of words found so far (in trial there are always words that does not seem to make sense or not proper word).
2. The filtering of 10 to 200 thousands of words take considerable time, more than I am willing to wait for to play a simple game.

Hence, the list of words of valid answers are then taken as an input.

NB:
Eldrow is Wordle in reverse, but I did not realize it is already used for a reverse wordle (and have no better idea)
