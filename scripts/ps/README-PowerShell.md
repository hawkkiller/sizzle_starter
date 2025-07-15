# PowerShell Scripts for Windows

This directory contains PowerShell equivalents of the bash scripts for Windows users.

## Scripts Available

- **`bootstrap.ps1`** - Gets Flutter dependencies and runs code generation for all packages with build_runner
- **`analyze.ps1`** - Runs Flutter analyze on the entire project
- **`clean.ps1`** - Cleans the workspace and all packages
- **`format.ps1`** - Formats all Dart code in the project (excluding generated files)
- **`test.ps1`** - Runs tests in all packages that have test directories

## Usage

Run any script from the project root using PowerShell:

```powershell
# Bootstrap the project (get dependencies and generate code)
powershell -ExecutionPolicy Bypass -File "scripts\ps\bootstrap.ps1"

# Analyze code
powershell -ExecutionPolicy Bypass -File "scripts\ps\analyze.ps1"

# Clean project
powershell -ExecutionPolicy Bypass -File "scripts\ps\clean.ps1"

# Format code
powershell -ExecutionPolicy Bypass -File "scripts\ps\format.ps1"

# Run tests
powershell -ExecutionPolicy Bypass -File "scripts\ps\test.ps1"
```

## Alternative: Using pwsh (PowerShell Core)

If you have PowerShell Core installed, you can run the scripts directly:

```powershell
# Make scripts executable (one time setup)
pwsh -c "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"

# Run scripts directly
pwsh scripts\ps\bootstrap.ps1
pwsh scripts\ps\analyze.ps1
pwsh scripts\ps\clean.ps1
pwsh scripts\ps\format.ps1
pwsh scripts\ps\test.ps1
```

## VS Code Tasks

You can also use the predefined VS Code tasks instead of running scripts manually:
- "Get dependencies" - equivalent to bootstrap (dependencies only)
- "Run codegen" - runs code generation
- "Format" - formats code
- "Run tests" - runs tests

Access these through VS Code's Command Palette (`Ctrl+Shift+P`) → "Tasks: Run Task"
