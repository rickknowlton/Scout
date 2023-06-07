# Scout v1.3.1
# Use to Scout to find node_modules in directories and subdirectories
# Author: Rick Knowlton 2023

#!/bin/bash

# Navigate to the Downloads directory (or directory of your choosing)
cd ~/Downloads

# Find all directories named "node_modules" (including those in subdirectories)
# and print their paths
directories=$(find . -depth -type d -name "node_modules" -print)

# Calculate the number of directories that were found
num_directories=$(echo "$directories" | wc -l)

# Display "Processing..." and make it blink until the search is complete
{
  while true; do
    echo -n "Processing..."
    sleep 0.5
    echo -en "\r             \r"
    sleep 0.5
  done
} &

# Calculate the total size of the directories
total_size=0
while read -r line; do
  # Get the size of the current directory
  size=$(du -s "$line" | awk '{print $1}')
  # Add the size to the total
  total_size=$((total_size + size))
done <<< "$directories"

# Convert the size from KB to GB
total_size_gb=$(echo "scale=2; $total_size / 1000000" | bc -l)

# Clear the "Processing..." message
echo -en "\r"

# Kill the "Processing..." script
kill $!

# Print the number of directories that were found and the total size
echo "$num_directories node_modules directories found."
echo "$total_size_gb GB can be saved if all node_modules in this directory are deleted."
