# Import the Power BI module
Import-Module -Name MicrosoftPowerBIMgmt

# Connect to Power BI
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-PowerBIServiceAccount


# Create a new workspace, current user is admin

New-PowerBIWorkspace -Name "WSNAME"


Connect-PowerBIServiceAccount

# Grab pointer to object and assign to capacity
$workspace1 = Get-PowerBIWorkspace -Scope Organization -Filter "name eq 'PBI JLC DEV DS Manuf Finance (JLC-CH)'"
Set-PowerBIWorkspace -Scope Organization -Id $workspace1.Id  -CapacityId "CapacityId"


# Add users
Add-PowerBIWorkspaceUser -Scope Organization -Id $workspace1.Id   -UserEmailAddress xxx@outlook.com -AccessRight Member
Add-PowerBIWorkspaceUser -Scope Organization -Id $workspace1.Id  -UserEmailAddress yyy@outlook.com -AccessRight Member





 
