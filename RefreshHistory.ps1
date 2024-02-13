
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-Module -Name MicrosoftPowerBIMgmt -AllowClobber

Connect-PowerBIServiceAccount



$Workspaces = Get-PowerBIWorkspace



foreach($workspace in $Workspaces)
{



$DataSets = Get-PowerBIDataset -WorkspaceId $workspace.Id | where {$_.isRefreshable -eq $true}
foreach($dataset in $DataSets)
{



$URI = "groups/" + $workspace.id + "/datasets/" + $dataset.id + "/refreshes"
#$OutFile = $ExportFolder + '\' + $workspace.Name + '-' + $dataset.Name + '.json'
$Results = Invoke-PowerBIRestMethod -Url $URI -Method Get | ConvertFrom-Json



foreach($result in $Results.value)
{
$errorDetails = $result.serviceExceptionJson | ConvertFrom-Json -ErrorAction SilentlyContinue



$row = New-Object psobject
$row | Add-Member -Name "Workspace" -Value $workspace.Name -MemberType NoteProperty
$row | Add-Member -Name "Dataset" -Value $dataset.Name -MemberType NoteProperty
$row | Add-Member -Name "refreshType" -Value $result.refreshType -MemberType NoteProperty
$row | Add-Member -Name "startTime" -Value $result.startTime -MemberType NoteProperty
$row | Add-Member -Name "endTime" -Value $result.endTime -MemberType NoteProperty
$row | Add-Member -Name "status" -Value $result.status -MemberType NoteProperty
$row | Add-Member -Name "errorCode" -Value $errorDetails.errorCode -MemberType NoteProperty
$row | Add-Member -Name "errorDescription" -Value $errorDetails.errorDescription -MemberType NoteProperty
#Write-Host $row
$row | Export-CSV D:\PSOutputs\refreshfull.csv -Append
}



}



}