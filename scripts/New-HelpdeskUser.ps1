<#
.SYNOPSIS
    Creates a new Active Directory user account.
.PARAMETER First
    User's first name.
.PARAMETER Last
    User's last name.
.PARAMETER Dept
    Department — must match an OU: IT, HR, Finance, Helpdesk
.PARAMETER Title
    User's job title.
.EXAMPLE
    .\New-HelpdeskUser.ps1 -First "Jane" -Last "Doe" -Dept "Finance" -Title "Finance Analyst"
#>
param(
    [Parameter(Mandatory=$true)] [string]$First,
    [Parameter(Mandatory=$true)] [string]$Last,
    [Parameter(Mandatory=$true)] [ValidateSet("IT","HR","Finance","Helpdesk")] [string]$Dept,
    [Parameter(Mandatory=$true)] [string]$Title
)

Import-Module ActiveDirectory -ErrorAction Stop

$Username     = ($First.Substring(0,1) + $Last).ToLower() -replace "\s",""
$TempPassword = ConvertTo-SecureString "Welcome@123!" -AsPlainText -Force
$OUPath       = "OU=$Dept,DC=helpdesk,DC=local"
$UPN          = "$Username@helpdesk.local"

if (Get-ADUser -Filter {SamAccountName -eq $Username} -ErrorAction SilentlyContinue) {
    Write-Host "ERROR: Username '$Username' already exists." -ForegroundColor Red; exit 1
}

New-ADUser -GivenName $First -Surname $Last -Name "$First $Last" -DisplayName "$First $Last" `
    -SamAccountName $Username -UserPrincipalName $UPN -Department $Dept -Title $Title `
    -Path $OUPath -AccountPassword $TempPassword -ChangePasswordAtLogon $true -Enabled $true `
    -Description "Created by Helpdesk on $(Get-Date -Format 'yyyy-MM-dd')"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  USER CREATED SUCCESSFULLY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Name     : $First $Last" -ForegroundColor White
Write-Host "  Username : $Username" -ForegroundColor White
Write-Host "  UPN      : $UPN" -ForegroundColor White
Write-Host "  Dept     : $Dept  |  Title: $Title" -ForegroundColor White
Write-Host "  Temp PW  : Welcome@123! (must change on login)" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
