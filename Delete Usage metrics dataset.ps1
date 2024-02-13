Get-Module -Name MicrosoftPowerBIMgmt -ListAvailable
Install-Module -Name MicrosoftPowerBIMgmt
Login-PowerBI
#get datasets in the wokrspace 
Invoke-PowerBIRestMethod -Url groups/WorkspaceId/datasets -Method Get
#delete dataset using datasetid
Invoke-PowerBIRestMethod -Url groups/WorkspaceId/datasets/DatasetId -Method Delete

