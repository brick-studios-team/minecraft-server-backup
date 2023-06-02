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

    # Get the folder name and convert it to lowercase
    REPO_NAME=$(basename "$folder")
    LOWERCASE_NAME=$(echo "$REPO_NAME" | tr '[:upper:]' '[:lower:]')

    # Check if the repository already exists
    gh repo view "aservers/$LOWERCASE_NAME" &> /dev/null
    REPO_EXISTS=$?

    if [ $REPO_EXISTS -eq 0 ]; then
      echo "Repository already exists: aservers/$LOWERCASE_NAME"
    else
      # Add a hyphen if the name contains lowercase letters
      if [[ "$REPO_NAME" != "$LOWERCASE_NAME" ]]; then
        LOWERCASE_NAME="$LOWERCASE_NAME-"
      fi

      # Initialize Git repository
      git init

      # Add all files to the repository
      git add .

      # Commit the changes
      git commit -m "initial commit"

      # Create the remote repository
      gh repo create "aservers/$LOWERCASE_NAME$REPO_NAME" --public --confirm

      # Set the remote origin
      git remote add origin "https://github.com/aservers/$LOWERCASE_NAME$REPO_NAME"

      # Push to the remote repository
      git push -u origin master

      echo "Repository created: aservers/$LOWERCASE_NAME$REPO_NAME"
    fi

    # Go back to the base folder
    cd "$BASE_FOLDER" || exit
  fi
done