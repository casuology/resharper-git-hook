# ReSharper Command Line Tools Git Hook

This is a pre-commit hook for git that will run code cleanup with [ReSharper Command Line Tools](https://www.jetbrains.com/help/resharper/ReSharper_Command_Line_Tools.html) on files that are being committed.

## Prerequisites

- [Git](https://git-scm.com/downloads)
- [.NET Core 3.0 SDK or later](https://dotnet.microsoft.com/download/dotnet/thank-you/sdk-3.1.403-windows-x64-installer)

## Installation

Open a terminal (git bash on Windows), navigate to the root of your git repository, and run the following command:

```bash
curl -s https://raw.githubusercontent.com/casuology/resharper-git-hook/main/install.sh | bash
```
