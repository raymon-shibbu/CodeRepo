#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Connect-PowerBIServiceAccount
Connect-MsolService

$pathToOutputFile = "D:\Scripts\Outputs\licenseinfo\LicensesUsers$(get-date -f .yyyyMMdd.HHmm).csv"

# Retrieve and export users
$allUsers = Get-MsolUser -All | Select-Object *, @{label = "LicensesText"; expression = { ($_.Licenses | ForEach-Object { $_.AccountSkuId }) -Join "," } } `
| Select-Object ObjectId, CompanyName, Department, DisplayName, UserPrincipalName, UserType, LicensesText

#Write-host $allUsers

$allUsers | Export-CSV $pathToOutputFile -NoTypeInformation 

#$allUsers | Add-AssessmentRecords -SinkContainer "LicensesUsers" -Config $Config

# Retrieve and export organizational licenses : https://docs.microsoft.com/en-us/office365/enterprise/powershell/view-licenses-and-services-with-office-365-powershell
# Write-AssessmentLog "Exporting organizational licenses..." -Config $Config
# $OrgM365Licenses = Get-MsolAccountSku | Select-Object @{label="SkuPartNumber";expression={$_.AccountSkuId}}, @{label="Enabled";expression={$_.ActiveUnits}},WarningUnits, ConsumedUnits
# $OrgM365Licenses | Add-AssessmentRecords -SinkContainer "LicensesOrgM365" -Config $Config

