#!/bin/bash

stagedFilesExcludingDeleted=$(git diff --cached --name-only --diff-filter=d)

if [ -z "$stagedFilesExcludingDeleted" ]; then
    echo "No files to perform code cleanup on"
    exit 0
fi

echo "Running code cleanup on: $stagedFilesExcludingDeleted"

echo "Running code cleanup..."
dotnet jb cleanupcode $stagedFilesExcludingDeleted

echo "Restaging files..."
git add $stagedFilesExcludingDeleted

exit 0
