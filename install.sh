#!/bin/bash

localGitDir="./.git"
localDotnetManifestFilePath="./.config/dotnet-tools.json"
localGitHooksDir="./.githooks"
localPreCommitFilePath="$localGitHooksDir/pre-commit"
preCommitFileUrl="https://raw.githubusercontent.com/casuology/resharper-git-hook/main/pre-commit.sh"

# If a .git folder does not exist, exit
if ! [ -d "$localGitDir" ]; then
    echo "Error: No .git folder found in the current directory"
    exit 1
fi

# If .NET is not installed, exit
if ! command -v dotnet &> /dev/null; then
    echo "Error: .NET is not installed"
    exit 1
fi

# If the installed .NET version is less than 3.0, exit
dotnetVersion=$(dotnet --version)
dotnetMajorVersion=$(echo $dotnetVersion | cut -d. -f1)
if [ $(("$dotnetMajorVersion")) -lt 3 ]; then
    echo "Error: .NET version must be >= 3.0"
    exit 1
fi

# If the .githooks folder does not exist, create it
if ! [ -d "$localGitHooksDir" ]; then
    echo "Info: Creating .githooks folder"
    mkdir "$localGitHooksDir"
fi

# If the pre-commit file does not exist, fetch it from the repository
if ! [ -f "$localPreCommitFilePath" ]; then
    echo "Info: Fetching pre-commit file from repository"
    curl -o "$localPreCommitFilePath" "$preCommitFileUrl"
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
