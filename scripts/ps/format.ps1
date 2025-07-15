#!/usr/bin/env pwsh
# PowerShell format script for Sizzle Starter

Write-Host "Formatting Dart code..." -ForegroundColor Green

# Run dart format in all packages of the project that have a pubspec.yaml file
@("app", "core", "feature") | ForEach-Object {
    $baseDir = $_
    if (Test-Path $baseDir) {
        Get-ChildItem -Path $baseDir -Recurse -Name "pubspec.yaml" | ForEach-Object {
            $pubspecPath = $_
            $dir = Split-Path $pubspecPath -Parent
            
            if (Test-Path "$dir\pubspec.yaml") {
                Write-Host "`nFormatting $dir" -ForegroundColor Yellow
                Push-Location $dir
                try {
                    $targets = @()
                    @("lib", "test") | ForEach-Object {
                        if (Test-Path $_) {
                            $targets += $_
                        }
                    }
                    
                    if ($targets.Count -gt 0) {
                        # Find all .dart files that are not generated files (don't contain .*.dart pattern)
                        $dartFiles = @()
                        foreach ($target in $targets) {
                            $files = Get-ChildItem -Path $target -Recurse -Filter "*.dart" | 
                                     Where-Object { $_.Name -notmatch '\..+\.dart$' }
                            $dartFiles += $files.FullName
                        }
                        
                        if ($dartFiles.Count -gt 0) {
                            dart format --line-length 100 $dartFiles
                        }
                    }
                }
                catch {
                    Write-Host "Error formatting $dir : $($_.Exception.Message)" -ForegroundColor Red
                }
                finally {
                    Pop-Location
                }
            }
        }
    }
}

Write-Host "`nFormatting completed!" -ForegroundColor Green
