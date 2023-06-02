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

