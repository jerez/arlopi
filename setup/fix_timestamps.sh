#!/bin/bash

# Directory containing the files
DIRECTORY="/share/arlo"

# Iterate through each file in the directory and all subdirectories
find "$DIRECTORY" -type f | while read -r FILE; do
    # Get the birth time of the file using `stat`
    BIRTH_TIME=$(stat --format='%w' "$FILE")

    # Check if birth time is available (some filesystems don't support birth time)
    if [ "$BIRTH_TIME" != "-" ]; then
        # Extract only the date and time, ignoring the nanoseconds
        BIRTH_TIME=$(echo "$BIRTH_TIME" | cut -d'.' -f1)

        echo "Setting modify time for $FILE to $BIRTH_TIME"
        
        # Set the modification time to the birth time
        touch -m -d "$BIRTH_TIME" "$FILE"
    else
        echo "Skipping $FILE: No birth time available"
    fi
done
