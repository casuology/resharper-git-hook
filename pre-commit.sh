#!/bin/bash

stagedFilesExcludingDeleted=$(git diff --cached --name-only --diff-filter=d)

echo "Running code cleanup on: $stagedFilesExcludingDeleted"

# If no files are staged, exit
if [ -z "$stagedFilesExcludingDeleted" ]; then
    echo "No files to perform code cleanup on"
    exit 0
fi

# Run code cleanup on the staged files
dotnet jb cleanupcode $stagedFilesExcludingDeleted
echo "Code cleanup completed successfully ✅"

# Restage the files
git add $stagedFilesExcludingDeleted
echo "Modified files staged ✅"

exit 0
