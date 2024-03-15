[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-PowerBIServiceAccount
Get-PowerBIDataflow -WorkspaceId 4972282b-4c07-4696-88a8-6eb8a8c01794 | ConvertTo-Csv -NoTypeInformation | Out-File 'filepath'