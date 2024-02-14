Install-Module -Name MicrosoftPowerBImgmt
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-PowerBIServiceAccount
#Input values before running the script:
$NbrDaysDaysToExtract = 1
$ExportFileLocation = 'D:\Scripts\Outputs\Activity-Log'
$ExportFileName = 'PBIActivityEvents'
#--------------------------------------------

#Start with yesterday for counting back to ensure full day results are obtained:
[datetime]$DayUTC = (([datetime]::Today.ToUniversalTime()).Date).AddDays(-1) 

#Suffix for file name so we know when it was written:
[string]$DateTimeFileWrittenUTCLabel = ([datetime]::Now.ToUniversalTime()).ToString("yyyyMMddHHmm")

#Loop through each of the days to be extracted (<Initilize> ; <Condition> ; <Repeat>)
For($LoopNbr=0 ; $LoopNbr -lt $NbrDaysDaysToExtract ; $LoopNbr++)
{
    [datetime]$DateToExtractUTC=$DayUTC.AddDays(-$LoopNbr).ToString("yyyy-MM-dd")

    [string]$DateToExtractLabel=$DateToExtractUTC.ToString("yyyy-MM-dd")
    
    #Create full file name:
    [string]$FullExportFileName = $ExportFileName `
    + '-' + ($DateToExtractLabel -replace '-', '') `
    + '-' + $DateTimeFileWrittenUTCLabel `
    + '.csv' 

    #Obtain activity events and store intermediary results:
    [psobject]$Events=Get-PowerBIActivityEvent `
        -StartDateTime ($DateToExtractLabel+'T00:00:00.000') `
        -EndDateTime ($DateToExtractLabel+'T23:59:59.999')  -ResultType Jsonstring

 
   
    #Convert from JSON so we can parse the data:
   $ConvertedResults =($Events| ConvertFrom-Json) | ConvertTo-Csv -NoTypeInformation

    #Write-Verbose  "converted: $ConvertedResults" -Verbose

    #Write one file per day:
    $ConvertedResults| Out-File "$ExportFileLocation\$FullExportFileName"

    Write-Verbose "File written: $FullExportFileName" -Verbose 
}
Write-Verbose "Extract of Power BI activity events is complete." -Verbose