#!/usr/bin/env pwsh
# PowerShell test script for Sizzle Starter

# Enable error handling
$ErrorActionPreference = "Stop"

Write-Host "Finding test directories..." -ForegroundColor Green

# Find directories with a pubspec.yaml and a test/ folder
$testDirs = @()

Get-ChildItem -Path . -Recurse -Name "pubspec.yaml" | ForEach-Object {
    $pubspecPath = $_
    $dir = Split-Path $pubspecPath -Parent
    
    if (Test-Path "$dir\test") {
        $testDirs += $dir
        Write-Host "Found test directory: $dir" -ForegroundColor Yellow
    }
}

if ($testDirs.Count -gt 0) {
    Write-Host "`nRunning tests in found directories..." -ForegroundColor Green
    
    # Create reports directory if it doesn't exist
    if (-not (Test-Path "reports")) {
        New-Item -ItemType Directory -Path "reports" | Out-Null
    }
    
    # Run flutter test with all test directories
    flutter test $testDirs --no-pub --coverage --file-reporter json:reports/tests.json
    
    Write-Host "`nTests completed!" -ForegroundColor Green
} else {
    Write-Host "No directories with pubspec.yaml and test/ folder found." -ForegroundColor Yellow
}
