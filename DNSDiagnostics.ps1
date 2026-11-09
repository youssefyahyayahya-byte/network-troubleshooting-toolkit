
# ============================================
# DNS Diagnostics Tool
# Author: Youssef Yahya
# Version: 1.0
# ============================================

Clear-Host

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "             DNS DIAGNOSTICS" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

$Domain = Read-Host "`nEnter domain name (example: google.com)"

if ([string]::IsNullOrWhiteSpace($Domain) -or
    $Domain -notmatch '^(?=.{1,253}$)([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,63}$') {

    Write-Host "`nInvalid domain name." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "`nChecking DNS server configuration..." -ForegroundColor Yellow

Get-DnsClientServerAddress -AddressFamily IPv4 |
    Where-Object { $_.ServerAddresses.Count -gt 0 } |
    Format-Table InterfaceAlias, ServerAddresses -AutoSize

$RecordTypes = @("A", "AAAA", "MX", "NS", "TXT")

foreach ($Type in $RecordTypes) {

    Write-Host "`n--------------------------------------------" -ForegroundColor DarkCyan
    Write-Host "Checking $Type Records..." -ForegroundColor Yellow

    try {
        $Results = Resolve-DnsName -Name $Domain -Type $Type -ErrorAction Stop

        $Results |
            Select-Object Name, Type, NameHost, IPAddress, MailExchange, Preference |
            Format-Table -AutoSize
    }
    catch {
        Write-Host "No $Type records found or DNS query failed." -ForegroundColor Red
    }
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "DNS Diagnostics Completed." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

Read-Host "`nPress Enter to exit"
