<#
.SYNOPSIS
    Modifies an existing Active Directory user.
.EXAMPLE
    .\Set-HelpdeskUser.ps1 -Username "jdoe" -NewTitle "Senior Analyst" -NewDept "IT"
#>
param(
    [Parameter(Mandatory=$true)] [string]$Username,
    [string]$NewTitle,
    [string]$NewDept,
    [string]$NewManager,
    [string]$NewPhone
)

Import-Module ActiveDirectory -ErrorAction Stop

$User = Get-ADUser -Identity $Username -Properties Title,Department,Manager,OfficePhone -ErrorAction SilentlyContinue
if (-not $User) { Write-Host "ERROR: User '$Username' not found." -ForegroundColor Red; exit 1 }

$UpdateParams = @{ Identity = $Username }
if ($NewTitle) { $UpdateParams["Title"]       = $NewTitle }
if ($NewDept)  { $UpdateParams["Department"]  = $NewDept  }
if ($NewPhone) { $UpdateParams["OfficePhone"] = $NewPhone }
if ($NewManager) {
    $Mgr = Get-ADUser -Identity $NewManager -ErrorAction SilentlyContinue
    if ($Mgr) { $UpdateParams["Manager"] = $Mgr.DistinguishedName }
}

Set-ADUser @UpdateParams
Write-Host "USER UPDATED: $Username" -ForegroundColor Cyan
if ($NewTitle) { Write-Host "  Title  : $NewTitle" -ForegroundColor White }
if ($NewDept)  { Write-Host "  Dept   : $NewDept"  -ForegroundColor White }
