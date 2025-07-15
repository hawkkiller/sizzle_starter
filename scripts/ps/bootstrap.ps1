#!/usr/bin/env pwsh
# PowerShell bootstrap script for Sizzle Starter
# Get workspace dependencies

Write-Host "Getting Flutter dependencies..." -ForegroundColor Green
flutter pub get

# For each package that has a pubspec.yaml file and build_runner dependency
# run generation
Write-Host "Finding packages with build_runner dependency..." -ForegroundColor Green

Get-ChildItem -Path . -Recurse -Name "pubspec.yaml" | ForEach-Object {
    $pubspecPath = $_
    $dir = Split-Path $pubspecPath -Parent
    
    # Check if pubspec.yaml contains build_runner
    $content = Get-Content $pubspecPath -Raw
    if ($content -match "build_runner") {
        Write-Host "`nGenerating files for $dir" -ForegroundColor Yellow
        Push-Location $dir
        try {
            dart run build_runner build -d
        }
        catch {
            Write-Host "Error running build_runner in $dir : $($_.Exception.Message)" -ForegroundColor Red
        }
        finally {
            Pop-Location
        }
    }
}

Write-Host "`nBootstrap completed!" -ForegroundColor Green
