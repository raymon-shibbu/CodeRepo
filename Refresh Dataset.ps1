#Gets User, workspace, workspaceId 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Find-Module -Name PowerShellGet
Install-Module -Name MicrosoftPowerBImgmt
Connect-PowerBIServiceAccount

Invoke-PowerBIRestMethod -Url 'datasets/1273ec29-c40d-40bd-b183-c3e0c3b53cb7/refreshes' -Method Post -Body('1273ec29-c40d-40bd-b183-c3e0c3b53cb7')