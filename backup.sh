#!/bin/bash

# Get the current working directory
BASE_FOLDER=$(pwd)

# Loop through each subfolder
for folder in "$BASE_FOLDER"/*; do
  if [ -d "$folder" ]; then
    # Get the .gitignore file from the base folder
    cp "$BASE_FOLDER/.gitignore" "$folder/.gitignore"

    # Navigate to the subfolder
    cd "$folder" || exit

    # Initialize Git repository
    git init

    # Add all files to the repository
    git add .

    # Commit the changes
    git commit -m "initial commit"

    # Add remote origin
    git remote add origin "https://github.com/aservers/$(basename "$folder")"

    # Push to the remote repository
    git push -u origin master

    # Go back to the base folder
    cd "$BASE_FOLDER" || exit
  fi
done