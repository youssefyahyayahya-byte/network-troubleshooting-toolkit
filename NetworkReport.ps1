
# ============================================
# Network Diagnostic Report Generator
# Author: Youssef Yahya
# Version: 1.0
# ============================================

Clear-Host

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "       NETWORK REPORT GENERATOR" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

$ReportFolder = Join-Path $PSScriptRoot "Reports"

if (-not (Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$ReportPath = Join-Path $ReportFolder "NetworkReport_$Timestamp.txt"

$Report = @()

$Report += "============================================"
$Report += "       NETWORK DIAGNOSTIC REPORT"
$Report += "============================================"
$Report += "Generated: $(Get-Date)"
$Report += "Computer: $env:COMPUTERNAME"
$Report += ""

# System information
$Report += "========== SYSTEM INFORMATION =========="

$OS = Get-CimInstance Win32_OperatingSystem

$Report += "Operating System: $($OS.Caption)"
$Report += "Version: $($OS.Version)"
$Report += "Architecture: $($OS.OSArchitecture)"
$Report += ""

# Network adapters
$Report += "========== NETWORK ADAPTERS =========="

$Adapters = Get-NetAdapter -ErrorAction SilentlyContinue

foreach ($Adapter in $Adapters) {
    $Report += "Adapter: $($Adapter.Name)"
    $Report += "Description: $($Adapter.InterfaceDescription)"
    $Report += "Status: $($Adapter.Status)"
    $Report += "MAC Address: $($Adapter.MacAddress)"
    $Report += "Speed: $($Adapter.LinkSpeed)"
    $Report += ""
}

# IP configuration
$Report += "========== IP CONFIGURATION =========="

$IPConfigurations = Get-NetIPConfiguration -ErrorAction SilentlyContinue

foreach ($IPConfig in $IPConfigurations) {
    $Report += "Interface: $($IPConfig.InterfaceAlias)"
    $Report += "IPv4: $($IPConfig.IPv4Address.IPAddress -join ', ')"
    $Report += "Gateway: $($IPConfig.IPv4DefaultGateway.NextHop -join ', ')"
    $Report += "DNS: $($IPConfig.DnsServer.ServerAddresses -join ', ')"
    $Report += ""
}

# Connectivity tests
$Report += "========== CONNECTIVITY TESTS =========="

$Targets = @("8.8.8.8", "1.1.1.1")

foreach ($Target in $Targets) {
    $Report += "Testing $Target ..."

    $Result = Test-Connection -ComputerName $Target -Count 2 -Quiet -ErrorAction SilentlyContinue

    if ($Result) {
        $Report += "Status: Ping response received"
    }
    else {
        $Report += "Status: No ping response"
    }

    $Report += ""
}

# DNS test
$Report += "========== DNS TEST =========="

try {
    $DNSResult = Resolve-DnsName google.com -ErrorAction Stop

    $Report += "DNS lookup: Successful"

    foreach ($Record in ($DNSResult | Where-Object { $_.IPAddress })) {
        $Report += "Resolved IP: $($Record.IPAddress)"
    }
}
catch {
    $Report += "DNS lookup: Failed"
    $Report += "Error: $($_.Exception.Message)"
}

$Report += ""
$Report += "========== END OF REPORT =========="

$Report | Out-File -FilePath $ReportPath -Encoding utf8

Write-Host "`nReport generated successfully!" -ForegroundColor Green
Write-Host "`nSaved location:" -ForegroundColor Yellow
Write-Host $ReportPath -ForegroundColor Cyan

Write-Host "`nOpen the Reports folder to view your report."

Read-Host "`nPress Enter to exit"
