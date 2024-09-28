#!/bin/bash

preCommitPath="./.git/hooks/pre-commit"
dotnetManifestPath="./.config/dotnet-tools.json"
preCommitUrl="https://raw.githubusercontent.com/casuology/resharper-git-hook/main/pre-commit.sh"

# If a .git folder does not exist, exit
if ! [ -d "./.git" ]; then
    echo "Error: No .git folder found in the current directory"
    exit 1
fi

# If .NET 3.0 or later is not installed, exit
if ! command -v dotnet &> /dev/null || [ $(dotnet --version | cut -d. -f1) -lt 3 ]; then
    echo "Error: .NET 3.0 or later is not installed"
    exit 1
fi

# Overwrite the hook file by fetching it from the repository
echo "Info: Fetching git hook file from repository"
curl -o "$preCommitPath" "$preCommitUrl"
chmod +x "$preCommitPath"

# If a dotnet tool manifest file does not exist, create it
if ! [ -f "$dotnetManifestPath" ]; then
    echo "Info: Creating dotnet tool manifest file"
    dotnet new tool-manifest
fi

# If on ARM64 Windows, install ReSharper Command Line Tools for Windows ARM64
if [[ "$(uname -m)" == "aarch64" && "$(uname -o)" == "Msys" ]]; then
    echo "Info: Installing ReSharper Command Line Tools for Windows ARM64"
    dotnet tool install JetBrains.ReSharper.GlobalTools --arch arm64
    exit 0
fi

# Install ReSharper Command Line Tools
echo "Info: Installing ReSharper Command Line Tools"
dotnet tool install JetBrains.ReSharper.GlobalTools
exit 0
