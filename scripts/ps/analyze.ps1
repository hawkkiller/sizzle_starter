#!/usr/bin/env pwsh
# PowerShell analyze script for Sizzle Starter

Write-Host "Running Flutter analyze..." -ForegroundColor Green
flutter analyze . --no-pub
