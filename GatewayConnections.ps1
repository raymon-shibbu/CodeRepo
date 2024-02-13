$Results= Invoke-PowerBIRestMethod -url "https://api.powerbi.com/v1.0/myorg/gateways/{"Datasetid"}/datasources" -Method Get | ConvertFrom-Json
foreach($result in $Results.value)
{
$URI = "https://api.powerbi.com/v1.0/myorg/gateways/{6a6468a4-6559-4ae0-b6b9-162119e8df8b}/datasources/{" + $result.id +"}/users"
#Write-Host $URI
$Connections= Invoke-PowerBIRestMethod -url $URI -Method Get | ConvertFrom-Json
#Write-Host $Connections


foreach($connection in $Connections.value)
{
$row = New-Object psobject
$row | Add-Member -Name "datasourceName" -value $result.datasourceName -MemberType NoteProperty
$row | Add-Member -Name "datasourceType" -value $result.datasourceType -MemberType NoteProperty
$row | Add-Member -Name "email" -value $connection.emailAddress -MemberType NoteProperty
$row | Add-Member -Name "datasourceAccessRight" -Value $connection.datasourceAccessRight -MemberType NoteProperty
$row | Add-Member -Name "displayName" -Value $connection.displayName -MemberType NoteProperty
$row | Add-Member -Name "identifier" -Value $connection.identifier -MemberType NoteProperty
$row | Add-Member -Name "principalType" -Value $connection.principalType -MemberType NoteProperty
#Write-Host $row
$row | Export-CSV D:\PSOutputs\gatewayuser.csv -Append

}
}