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