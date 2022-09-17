#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t -c"

ADD_NUMBER_TO_GUESS() {
  NUMBER_TO_GUESS=$(( ( RANDOM % 1000 )  + 1 ))
}

PLAY_ROUND() {
  echo "Guess the secret number between 1 and 1000:"
  echo "The number is $NUMBER_TO_GUESS"
  read USER_NUMBER
  ATTEMPTS=$((ATTEMPTS+1))
}

CHECK_NUMBER() {
  if [[ $1 != $NUMBER_TO_GUESS ]]
  then
    echo "Not good"
  else
    echo "Yay"
  fi
}

PLAY_GAME() {
  ADD_NUMBER_TO_GUESS
  ATTEMPTS=0
  PLAY_ROUND
  CHECK_NUMBER $USER_NUMBER
}

echo "Enter your username:"
read USER_NAME

# Get user_id from database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USER_NAME';")

if [[ -z $USER_ID ]]
then
  # Create new user
  USER_INSERT=$($PSQL "INSERT INTO users(name) VALUES('$USER_NAME');")
  # Greet new user
  echo "Welcome, $USER_NAME! It looks like this is your first time here."

  # Play game
  PLAY_GAME
else
  # Get number of played games
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM users AS u
                        INNER JOIN users_games USING(user_id)
                        INNER JOIN games USING(game_id)
                        WHERE u.user_id = $USER_ID;")
  # Greet existing user
  echo ""

  # Play game
fi