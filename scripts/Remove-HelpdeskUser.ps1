<#
.SYNOPSIS
    Offboards a user — disables, strips groups, archives to Disabled_Users OU.
.EXAMPLE
    .\Remove-HelpdeskUser.ps1 -Username "jdoe" -TicketID "2089"
    .\Remove-HelpdeskUser.ps1 -Username "jdoe" -Delete -TicketID "2089"
#>
param(
    [Parameter(Mandatory=$true)] [string]$Username,
    [string]$TicketID = "N/A",
    [switch]$Delete
)

Import-Module ActiveDirectory -ErrorAction Stop
$DisabledOU = "OU=Disabled_Users,DC=helpdesk,DC=local"

$User = Get-ADUser -Identity $Username -Properties MemberOf -ErrorAction SilentlyContinue
if (-not $User) { Write-Host "ERROR: User '$Username' not found." -ForegroundColor Red; exit 1 }

Write-Host "OFFBOARDING: $Username (Ticket: $TicketID)" -ForegroundColor Yellow

# Step 1: Disable
Disable-ADAccount -Identity $Username
Write-Host "  [1/3] Account disabled." -ForegroundColor Green

# Step 2: Remove groups
$Groups = (Get-ADUser $Username -Properties MemberOf).MemberOf
$Groups | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $Username -Confirm:$false -ErrorAction SilentlyContinue }
Write-Host "  [2/3] Removed from $($Groups.Count) group(s)." -ForegroundColor Green

# Step 3: Move to Disabled_Users
Get-ADUser $Username | Move-ADObject -TargetPath $DisabledOU
Write-Host "  [3/3] Moved to Disabled_Users OU." -ForegroundColor Green

if ($Delete) {
    $Confirm = Read-Host "Type DELETE to permanently remove the account"
    if ($Confirm -eq "DELETE") { Remove-ADUser -Identity $Username -Confirm:$false; Write-Host "  DELETED permanently." -ForegroundColor Red }
}

Write-Host "OFFBOARDING COMPLETE — Ticket: $TicketID | $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Green
