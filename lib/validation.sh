#!/bin/bash
validate_file()
{
if [[ $# -eq 0 ]]; then
echo "Error: No file argument provided "
return 1
fi

local file="$1"

# Check if the file exists and is a regular file
if [[ ! -f "$file" || ! -e "$file" ]]; then
echo "Error: $file does not exist or is not a regular file"
        return 1
fi
 # Check read permission
if [[ ! -r "$file" ]]; then
echo "Error: $file is not readable"
        return 1
fi

# Check file extension
if [[ "$file" != *.log ]]; then
echo "Error: Unsupported file extension: $file"
        return 1
fi
# Check if file is empty
if [[ ! -s "$file" ]]; then
echo "Warning: $file is empty"
        return 0
fi

# File is valid
echo "Valid: $file"
    return 0
}
