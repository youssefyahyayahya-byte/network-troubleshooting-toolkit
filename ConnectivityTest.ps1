
# ============================================
# Network Connectivity Test
# Author: Youssef Yahya
# ============================================

Clear-Host

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "       NETWORK CONNECTIVITY TEST" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

$Target = Read-Host "`nEnter IP Address or Hostname"

if ([string]::IsNullOrWhiteSpace($Target) -or $Target -match '[\s/\\]') {
    Write-Host "`nInvalid input." -ForegroundColor Red
    return
}

Write-Host "`nResolving hostname..." -ForegroundColor Yellow

try {
    $Resolved = Resolve-DnsName -Name $Target -ErrorAction Stop |
        Where-Object { $_.Type -in @("A", "AAAA") } |
        Select-Object -ExpandProperty IPAddress -Unique

    if ($Resolved) {
        Write-Host "Resolved IP: $($Resolved -join ', ')" -ForegroundColor Green
    }
}
catch {
    Write-Host "DNS resolution unavailable or target is an IP address." -ForegroundColor Yellow
}

Write-Host "`nStarting Ping Test..." -ForegroundColor Yellow

$PingResults = Test-Connection -ComputerName $Target -Count 4 -ErrorAction SilentlyContinue

if ($PingResults) {
    $Successful = @($PingResults).Count
    $Average = ($PingResults | Measure-Object -Property Latency -Average).Average

    Write-Host "`nPing Results:" -ForegroundColor Cyan
    Write-Host "Successful Replies: $Successful / 4"
    Write-Host "Average Latency: $([math]::Round($Average, 2)) ms" -ForegroundColor Green
}
else {
    Write-Host "No ping replies received." -ForegroundColor Red
    Write-Host "The target may be offline or blocking ICMP traffic." -ForegroundColor Yellow
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Connectivity test completed." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

Read-Host "`nPress Enter to exit"
