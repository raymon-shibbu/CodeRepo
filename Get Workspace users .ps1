#Gets User, workspace, workspaceId 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-PowerBIServiceAccount
Get-PowerBIWorkspace -Scope Organization -Include All -All  | 
ForEach-Object {
$Workspace = $_.name
$WorkspaceId = $_.Id
foreach ($User in $_.Users) {
[PSCustomObject]@{
Workspace = $Workspace
WorkspaceId = $WorkspaceId
User = $User.accessright    
Identifier   =$user.Identifier}}} | Export-CSV "D:\PSScripts\WorkspaceDetails.csv" -NoTypeInformation