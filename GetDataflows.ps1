[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-PowerBIServiceAccount
Get-PowerBIDataflow -WorkspaceId xxxxxx | ConvertTo-Csv -NoTypeInformation | Out-File 'filepath'
