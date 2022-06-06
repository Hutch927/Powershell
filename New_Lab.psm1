
function Get-SystemInfo{
    [cmdletbinding()]
          
    Param(
       [Parameter(valuefrompipeline = $true, ValuefromPipelineByPropertyName = $true)]
       [string[]]$computername
         )
                                
      foreach($computer in $computername){
                                                                                   
        $OSinfo = Get-WmiObject Win32_OperatingSystem -ComputerName $computer | Select-Object Caption,LastBootUpTime 
        $BootTime = Get-WmiObject Win32_OperatingSystem | Select-Object @{label='LastBoot';expression={$_.ConvertToDateTime($_.LastBootUpTime)}}            
        $currentdate = (Get-Date) 
        $UpTime = NEW-TIMESPAN –Start $BootTime.LastBoot –End (Get-Date) | Select-Object -ExpandProperty TotalHours | ForEach-Object {$_.ToString("###.## Hrs")} 
        $Cdrive = Get-WmiObject Win32_logicalDisk -Filter "DeviceID = 'C:'" -ComputerName $computer -ErrorAction SilentlyContinue
        $C_InGB = $Cdrive.FreeSpace / 1GB -as [int]
                                                                                                                        
        $properties = [ordered]@{
             "Computer Name" = $Computer
             "Operating System" = $OSinfo.Caption
             "Last Boot Time" = $BootTime.LastBoot  
             "Up Time in Hours" = $UpTime
             "Free Space on C:\" = $C_InGB.ToString("### GBs")}
    }
                                                                                                                                                                                                                                 
        $object = New-Object -TypeName PSObject -Property $properties
        $FormatEnumerationLimit= -1
        Write-Output $object  
                                                                                                                                                                                                                                                                         
        $object | Export-Csv -NoTypeInformation -Path C:\PropertiesChallange.csv -Append
                                                                                                                                                                                                                                                                                             
    }
                                                                                                                                                                                                                                                                                                      
    
    
    
                                                                                                                                                                                                                                                                                                          
    function Test-ADComputer{
    [cmdletbinding()]
    
    Param($Computers = (Get-ADComputer -Filter * | Select-Object -ExpandProperty DNSHostName))
                                                                                                                                                                                                                                                                                                                                  
    ForEach($Computer in $Computers){
                                                                                                                                                                                                                                                                                                                                              
            IF (Test-Connection -ComputerName $Computer  -BufferSize 32 -Quiet -Count 1){ 
                Write-Host "Successful Connection to $Computer `n"
                #$Computers               
                } else {
                Write-Host "Failed Connection to $Computer `n"
                    }
                      
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    }
    
    
    
    
    function Add-Users{
    [cmdletbinding()]
    
    $CSVPath = Read-Host -Prompt "Please type the path of the CSV file containing users to be added"
    $users = Import-Csv -Path $CSVPath
    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                                                   
Function Add-UserToGroup {
    
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Path to CSV file")]
    
    [string] $Path = "",
                            
        [Parameter(
            Mandatory = $false,
            HelpMessage = "CSV file delimiter")]
    
    [string] $Delimiter = ",",
                                                     
           [Parameter(
            Mandatory = $false,
            HelpMessage = "Find users on DisplayName, Email or UserPrincipalName")]
    
    [ValidateSet("DisplayName", "Email", "UserPrincipalName")]
    
    [string] $Filter = "DisplayName"
    )
                                   
    
    process{
        # Import the CSV File
        $users = Import-Csv -Path $path -Delimiter $delimiter
                                                                                                                   
        # Find the users in the Active Directory
        $users | ForEach-Object {
            $user = Get-ADUser -filter "$filter -eq '$($_.user)'" | Select-Object ObjectGUID 
                                                                                                                                         
                if ($user) {
                    Add-ADGroupMember -Identity $_.Group -Members $user
                    Write-Host "$($_.user) added to $($_.Group)"
                }else {
                    Write-Warning "$($_.user) not found in the Active Directory"
                        }
                   }
            }
    }
                                                                                                                                                                                                                         
                                                                                                                                                                                                                         
    Import-Module -Name ActiveDirectory
                                                                                                                                                                                                                         
                                                                                                                                                                                                                         
    Add-UserToGroup                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    <#
    Get-ADComputer -Filter * |
    ForEach-Object  {"$_"; Test-Connection -Quiet -BufferSize 32 -Count 1 -ComputerName $_.name ;""}    
    #>  