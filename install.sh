#!/bin/bash

localPreCommitFilePath="./.git/hooks/pre-commit"
localDotnetManifestFilePath="./.config/dotnet-tools.json"
preCommitFileUrl="https://raw.githubusercontent.com/casuology/resharper-git-hook/main/pre-commit.sh"

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

# If the pre-commit file does not exist, fetch it from the repository
if ! [ -f "$localPreCommitFilePath" ]; then
    echo "Info: Fetching pre-commit file from repository"
    curl -o "$localPreCommitFilePath" "$preCommitFileUrl"
    chmod +x "$localPreCommitFilePath"
fi

# If a dotnet tool manifest file does not exist, create it
if ! [ -f "$localDotnetManifestFilePath" ]; then
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
