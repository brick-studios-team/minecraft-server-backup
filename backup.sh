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

    # Check if the repository already exists
    REPO_NAME=$(basename "$folder")
    gh repo view "aservers/$REPO_NAME" &> /dev/null
    REPO_EXISTS=$?

    if [ $REPO_EXISTS -eq 0 ]; then
      echo "Repository already exists: aservers/$REPO_NAME"
    else
      # Initialize Git repository
      git init

      # Add all files to the repository
      git add .

      # Commit the changes
      git commit -m "initial commit"

      # Create the remote repository
      gh repo create "aservers/$REPO_NAME" --public --confirm

      # Set the remote origin
      git remote add origin "https://github.com/aservers/$REPO_NAME"

      # Push to the remote repository
      git push -u origin master

      echo "Repository created: aservers/$REPO_NAME"
    fi

    # Go back to the base folder
    cd "$BASE_FOLDER" || exit
  fi
done