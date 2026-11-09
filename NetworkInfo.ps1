
# ============================================
# Network Adapter Information Tool
# Author: Youssef Yahya
# ============================================

Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       NETWORK ADAPTER INFORMATION" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nDetecting network adapters..." -ForegroundColor Yellow

$Adapters = Get-NetAdapter -ErrorAction SilentlyContinue

if (-not $Adapters) {
    Write-Host "No network adapters found or command unavailable." -ForegroundColor Red
    return
}

foreach ($Adapter in $Adapters) {

    Write-Host "`n----------------------------------------" -ForegroundColor DarkCyan

    Write-Host "Adapter Name : $($Adapter.Name)"
    Write-Host "Description  : $($Adapter.InterfaceDescription)"
    Write-Host "Status       : $($Adapter.Status)"
    Write-Host "MAC Address  : $($Adapter.MacAddress)"
    Write-Host "Link Speed   : $($Adapter.LinkSpeed)"
    Write-Host "Interface ID : $($Adapter.InterfaceIndex)"

    $IPConfig = Get-NetIPConfiguration -InterfaceIndex $Adapter.InterfaceIndex -ErrorAction SilentlyContinue

    if ($IPConfig) {
        Write-Host "IPv4 Address : $($IPConfig.IPv4Address.IPAddress -join ', ')"
        Write-Host "Gateway      : $($IPConfig.IPv4DefaultGateway.NextHop -join ', ')"
        Write-Host "DNS Servers  : $($IPConfig.DnsServer.ServerAddresses -join ', ')"
    }
    else {
        Write-Host "IP Configuration: Not available"
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Network adapter scan completed." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
