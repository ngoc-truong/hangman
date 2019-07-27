# Hangman

## Description
This is a hangman game which can by played on the console. This game is written in ruby and is part of 
the [Odin Project](https://www.theodinproject.com/lessons/file-i-o-and-serialization), a self-paced web-development 
curriculum. This project helps to learn about file I/O and serialization in Ruby by including external files and saving
information/objects into files via serialization (in this case: JSON-format).

## Game objective
The computer chooses a word with 5 - 12 characters randomly from a dictionary file. The user has to guess the word by guessing
characters. The number of characters is displayed on the screen by underscores "_". If a guessed character is in the target word, 
its position in the word will be displayed on the screen (and replace the underscore). The user has 10 attempts to solve the word. 