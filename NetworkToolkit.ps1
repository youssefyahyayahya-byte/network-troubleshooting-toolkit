
# ============================================
# Network Troubleshooting Toolkit
# Main Launcher
# Author: Youssef Yahya
# Version: 1.1
# ============================================

$ErrorActionPreference = "Continue"

function Show-Header {
    Clear-Host

    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "       NETWORK TROUBLESHOOTING TOOLKIT" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "          Developed by Youssef Yahya" -ForegroundColor Yellow
    Write-Host "============================================" -ForegroundColor Cyan
}

function Start-Tool {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FileName
    )

    $ToolPath = Join-Path $PSScriptRoot $FileName

    if (-not (Test-Path $ToolPath -PathType Leaf)) {
        Write-Host "`nTool file not found: $FileName" -ForegroundColor Red
        Read-Host "Press Enter to return"
        return
    }

    try {
        & $ToolPath
    }
    catch {
        Write-Host "`nAn error occurred while running the tool:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        Read-Host "Press Enter to return"
    }

    if ($FileName -eq "NetworkInfo.ps1") {
        Read-Host "`nPress Enter to return to the main menu"
    }
}

while ($true) {

    Show-Header

    Write-Host "`n1. Network Adapter Information"
    Write-Host "2. Network Connectivity Test"
    Write-Host "3. DNS Diagnostics"
    Write-Host "4. Generate Network Report"
    Write-Host "5. Exit"

    Write-Host "`n============================================" -ForegroundColor Cyan

    $Choice = Read-Host "Select an option (1-5)"

    switch ($Choice) {

        "1" {
            Start-Tool "NetworkInfo.ps1"
        }

        "2" {
            Start-Tool "ConnectivityTest.ps1"
        }

        "3" {
            Start-Tool "DNSDiagnostics.ps1"
        }

        "4" {
            Start-Tool "NetworkReport.ps1"
        }

        "5" {
            Write-Host "`nThank you for using Network Toolkit!" -ForegroundColor Green
            return
        }

        default {
            Write-Host "`nInvalid option. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}
