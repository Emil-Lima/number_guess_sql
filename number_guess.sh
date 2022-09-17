#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t -c"

echo "Enter your username:"
read USER_NAME

# Get user_id from database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USER_NAME';")

if [[ -z $USER_ID ]]
then
  # Create new user
  USER_INSERT=$($PSQL "INSERT INTO users(name) VALUES('$USER_NAME');")
  # Gree new user
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
else
  # Get number of played games
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM users AS u
                        INNER JOIN users_games USING(user_id)
                        INNER JOIN games USING(game_id)
                        WHERE u.user_id = $USER_ID;")
  # Greet existing user
  echo ""
fi