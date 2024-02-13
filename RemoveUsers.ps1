# Import the Power BI module
Import-Module -Name MicrosoftPowerBIMgmt

# Connect to Power BI
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-PowerBIServiceAccount

# Set the path to the CSV file containing the list of workspaces and user names
$csvFilePath = "C:\path\to\file.csv"

# Read the CSV file into a variable
$users = Import-Csv -Path $csvFilePath

# Loop through the rows in the CSV file
foreach ($user in $users) {
  # Get the workspace ID and user name from the current row
  $workspaceId = $user.WorkspaceId
  $userName = $user.UserName

  # Remove the user from the workspace
  #Remove-PowerBIWorkspaceUser -WorkspaceId $workspaceId -UserName $userName
  Remove-PowerBIWorkspaceUser -Scope Individual -Id $workspaceId  -UserEmailAddress $userName
}