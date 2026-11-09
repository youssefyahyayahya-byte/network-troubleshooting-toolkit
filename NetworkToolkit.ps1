
# ============================================
# Network Troubleshooting Toolkit
# Version: 1.0
# Author: Youssef Yahya
# Platform: Windows PowerShell
# ============================================

Clear-Host

$ReportFolder = Join-Path $PSScriptRoot "Reports"

if (-not (Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

function Show-Header {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "       NETWORK TROUBLESHOOTING TOOLKIT" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "        Developed by Youssef Yahya" -ForegroundColor Yellow
    Write-Host "============================================" -ForegroundColor Cyan
}

function Show-SystemInfo {
    Show-Header
    Write-Host "`nSYSTEM INFORMATION" -ForegroundColor Yellow

    Get-CimInstance Win32_OperatingSystem |
        Select-Object CSName, Caption, Version, OSArchitecture

    Get-CimInstance Win32_Processor |
        Select-Object -First 1 Name

    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-NetworkInfo {
    Show-Header
    Write-Host "`nNETWORK CONFIGURATION" -ForegroundColor Yellow

    Get-NetIPConfiguration |
        Format-List InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer

    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Test-InternetConnection {
    Show-Header
    Write-Host "`nINTERNET CONNECTIVITY TEST" -ForegroundColor Yellow

    $targets = @("8.8.8.8", "1.1.1.1")

    foreach ($target in $targets) {
        Write-Host "`nTesting $target ..." -ForegroundColor Cyan

        if (Test-Connection -ComputerName $target -Count 2 -Quiet -ErrorAction SilentlyContinue) {
            Write-Host "Connection successful." -ForegroundColor Green
        }
        else {
            Write-Host "No ping response. This does not always mean the internet is down." -ForegroundColor Red
        }
    }

    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Test-DNS {
    Show-Header
    Write-Host "`nDNS DIAGNOSTICS" -ForegroundColor Yellow

    $domain = Read-Host "Enter domain name (example: google.com)"

    try {
        Resolve-DnsName -Name $domain -ErrorAction Stop |
            Select-Object Name, Type, IPAddress |
            Format-Table -AutoSize
    }
    catch {
        Write-Host "DNS lookup failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Create-NetworkReport {
    Show-Header
    Write-Host "`nGENERATING NETWORK REPORT" -ForegroundColor Yellow

    $date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $reportPath = Join-Path $ReportFolder "NetworkReport_$date.txt"

    "NETWORK TROUBLESHOOTING REPORT" | Out-File $reportPath
    "Generated: $(Get-Date)" | Out-File $reportPath -Append
    "`nSYSTEM INFORMATION" | Out-File $reportPath -Append

    Get-CimInstance Win32_OperatingSystem |
        Format-List CSName, Caption, Version, OSArchitecture |
        Out-String | Out-File $reportPath -Append

    "`nNETWORK CONFIGURATION" | Out-File $reportPath -Append

    Get-NetIPConfiguration |
        Format-List InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer |
        Out-String | Out-File $reportPath -Append

    "`nDNS TEST" | Out-File $reportPath -Append

    try {
        Resolve-DnsName google.com -ErrorAction Stop |
            Format-Table -AutoSize |
            Out-String | Out-File $reportPath -Append
    }
    catch {
        "DNS lookup failed." | Out-File $reportPath -Append
    }

    Write-Host "`nReport saved successfully:" -ForegroundColor Green
    Write-Host $reportPath -ForegroundColor Cyan

    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-Menu {
    while ($true) {
        Show-Header

        Write-Host "`n1. System Information"
        Write-Host "2. Network Configuration"
        Write-Host "3. Internet Connectivity Test"
        Write-Host "4. DNS Diagnostics"
        Write-Host "5. Generate Network Report"
        Write-Host "6. Exit"

        Write-Host "`n============================================" -ForegroundColor Cyan

        $choice = Read-Host "Select an option (1-6)"

        switch ($choice) {
            "1" { Show-SystemInfo }
            "2" { Show-NetworkInfo }
            "3" { Test-InternetConnection }
            "4" { Test-DNS }
            "5" { Create-NetworkReport }
            "6" {
                Write-Host "`nThank you for using Network Toolkit!" -ForegroundColor Green
                return
            }
            default {
                Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

Show-Menu
