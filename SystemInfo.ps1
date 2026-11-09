
# ============================================
# System Information Tool
# Author: Youssef Yahya
# Version: 1.0
# ============================================

Clear-Host

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "             SYSTEM INFORMATION" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

try {
    $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    $Computer = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
    $Processor = Get-CimInstance Win32_Processor -ErrorAction Stop |
        Select-Object -First 1
    $BIOS = Get-CimInstance Win32_BIOS -ErrorAction Stop

    $LastBoot = $OS.LastBootUpTime
    $Uptime = (Get-Date) - $LastBoot

    Write-Host "`nCOMPUTER DETAILS" -ForegroundColor Yellow
    Write-Host "Computer Name : $($Computer.Name)"
    Write-Host "Manufacturer  : $($Computer.Manufacturer)"
    Write-Host "Model         : $($Computer.Model)"
    Write-Host "BIOS Version  : $($BIOS.SMBIOSBIOSVersion)"

    Write-Host "`nOPERATING SYSTEM" -ForegroundColor Yellow
    Write-Host "OS Name       : $($OS.Caption)"
    Write-Host "Version       : $($OS.Version)"
    Write-Host "Build Number  : $($OS.BuildNumber)"
    Write-Host "Architecture  : $($OS.OSArchitecture)"

    Write-Host "`nPROCESSOR" -ForegroundColor Yellow
    Write-Host "CPU           : $($Processor.Name)"
    Write-Host "Logical CPUs  : $($Processor.NumberOfLogicalProcessors)"

    Write-Host "`nMEMORY" -ForegroundColor Yellow
    Write-Host "Total RAM     : $([math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)) GB"

    Write-Host "`nSYSTEM UPTIME" -ForegroundColor Yellow
    Write-Host "Last Boot     : $LastBoot"
    Write-Host "Uptime        : $($Uptime.Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes"

}
catch {
    Write-Host "`nUnable to retrieve all system information." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "System information scan completed." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

Read-Host "`nPress Enter to return"
