# Install the Power BI module if not installed
if (!(Get-Module -ListAvailable -Name MicrosoftPowerBIMgmt)) {
    Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser -Force -AllowClobber
}

# Import the module
Import-Module MicrosoftPowerBIMgmt

# Authenticate with Power BI (Interactive Login)
$token = Connect-PowerBIServiceAccount

# Get all workspaces
$workspaces = Get-PowerBIWorkspace -Scope Organization -All

# Initialize an array to store refresh schedules
$refreshSchedules = @()

# Loop through each workspace to get datasets and dataflows
foreach ($workspace in $workspaces) {
    Write-Host "Processing Workspace: $($workspace.Name)"

    # Get Datasets
    $datasets = Get-PowerBIDataset -WorkspaceId $workspace.Id
    foreach ($dataset in $datasets) {
        $refreshSchedule = Invoke-PowerBIRestMethod -Url "groups/$($workspace.Id)/datasets/$($dataset.Id)/refreshSchedule" -Method Get
        $refreshData = $refreshSchedule | ConvertFrom-Json

        $refreshSchedules += [PSCustomObject]@{
            WorkspaceName   = $workspace.Name
            ObjectType      = "Dataset"
            ObjectName      = $dataset.Name
            RefreshEnabled  = $refreshData.enabled
            RefreshTimes    = ($refreshData.times -join ", ")
            RefreshDays     = ($refreshData.days -join ", ")
            TimeZone        = $refreshData.timeZone
        }
    }

    # Get Dataflows
    $dataflows = Invoke-PowerBIRestMethod -Url "groups/$($workspace.Id)/dataflows" -Method Get | ConvertFrom-Json
    foreach ($dataflow in $dataflows.value) {
        $refreshSchedule = Invoke-PowerBIRestMethod -Url "groups/$($workspace.Id)/dataflows/$($dataflow.objectId)/refreshSchedule" -Method Get
        $refreshData = $refreshSchedule | ConvertFrom-Json

        $refreshSchedules += [PSCustomObject]@{
            WorkspaceName   = $workspace.Name
            ObjectType      = "Dataflow"
            ObjectName      = $dataflow.name
            RefreshEnabled  = $refreshData.enabled
            RefreshTimes    = ($refreshData.times -join ", ")
            RefreshDays     = ($refreshData.days -join ", ")
            TimeZone        = $refreshData.timeZone
        }
    }
}

# Export results to CSV
$exportPath = "$env:USERPROFILE\Desktop\PowerBI_Refresh_Schedules.csv"
$refreshSchedules | Export-Csv -Path $exportPath -NoTypeInformation -Encoding UTF8

Write-Host "Export completed. File saved at: $exportPath"
