<#
.SYNOPSIS
    Resets a user's password and unlocks their account.
.EXAMPLE
    .\Reset-HelpdeskPassword.ps1 -Username "jdoe" -TicketID "1042"
#>
param(
    [Parameter(Mandatory=$true)] [string]$Username,
    [Parameter(Mandatory=$true)] [string]$TicketID
)

Import-Module ActiveDirectory -ErrorAction Stop
$TempPassword = ConvertTo-SecureString "TempPass@1!" -AsPlainText -Force

$User = Get-ADUser -Identity $Username -Properties LockedOut,Enabled -ErrorAction SilentlyContinue
if (-not $User)       { Write-Host "ERROR: User '$Username' not found." -ForegroundColor Red; exit 1 }
if (-not $User.Enabled) { Write-Host "ERROR: Account is DISABLED — escalate to L2." -ForegroundColor Red; exit 1 }

Set-ADAccountPassword  -Identity $Username -NewPassword $TempPassword -Reset
Set-ADUser             -Identity $Username -ChangePasswordAtLogon $true
Unlock-ADAccount       -Identity $Username

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  PASSWORD RESET COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Username  : $Username" -ForegroundColor White
Write-Host "  Ticket ID : $TicketID" -ForegroundColor White
Write-Host "  Temp PW   : TempPass@1!" -ForegroundColor Yellow
Write-Host "  Unlocked  : Yes | Must change: Yes" -ForegroundColor White
Write-Host "  Completed : $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "--- PASTE THIS INTO ZENDESK TICKET ---" -ForegroundColor DarkGray
Write-Host "Password reset completed for: $Username" -ForegroundColor DarkGray
Write-Host "Ticket: #$TicketID | Actions: Reset, must-change enabled, unlocked." -ForegroundColor DarkGray
Write-Host "Temp password communicated to user via Zendesk reply." -ForegroundColor DarkGray
Write-Host "--------------------------------------" -ForegroundColor DarkGray
