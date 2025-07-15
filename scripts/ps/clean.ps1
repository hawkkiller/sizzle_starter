#!/usr/bin/env pwsh
# PowerShell clean script for Sizzle Starter

Write-Host "Cleaning workspace..." -ForegroundColor Green
flutter clean

Write-Host "Cleaning packages..." -ForegroundColor Green

# Clean packages in core and feature directories
@("core", "feature") | ForEach-Object {
    $dir = $_
    if (Test-Path "$dir\pubspec.yaml") {
        Write-Host "Cleaning $dir" -ForegroundColor Yellow
        Push-Location $dir
        try {
            flutter clean
        }
        catch {
            Write-Host "Error cleaning $dir : $($_.Exception.Message)" -ForegroundColor Red
        }
        finally {
            Pop-Location
        }
    }
}

Write-Host "Clean completed!" -ForegroundColor Green
