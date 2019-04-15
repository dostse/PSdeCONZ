function Get-DeconzAPIKey{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [string[]]$Name
    )
    
    BEGIN{
        $FullURI = "$URI/$APIKey"

    }
    PROCESS{

        if($PSBoundParameters.ContainsKey('Name')){
            $Keys = (((Invoke-WebRequest -Uri "$($FullURI)/config/").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.Name -eq 'Whitelist'}).Value | ForEach-Object -Process{$_.PSObject.Properties | Where-Object {$_.Value.Name -eq $Name}}
        
            foreach($Key in $Keys){
        
                $Properties = [ordered]@{'Name' = $Key.Value.Name
                                        'APIKey' = $Key.Name
                                        'Created' = $Key.Value.'create date'
                                        'LastUsed' = $Key.Value.'last use date'
                                        }
    
                $obj = New-Object -TypeName psobject -Property $Properties
                Write-Output $obj
            }
        }
        else{
            $Keys = (((Invoke-WebRequest -Uri "$($FullURI)/config/").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.Name -eq 'Whitelist'}).Value
            
            foreach($Key in ($Keys.PSObject.Properties | Sort-Object -Property Value.Name)){
        
                $Properties = [ordered]@{'Name' = $Key.Value.Name
                                        'APIKey' = $Key.Name
                                        'Created' = $Key.Value.'create date'
                                        'LastUsed' = $Key.Value.'last use date'
                                        }
    
                $obj = New-Object -TypeName psobject -Property $Properties
                Write-Output $obj
            }
        }
        
    }
    END{}

}
