function New-DeconzAPIKey{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$DeviceType
    )
       
    Try{

        $Body = @{'devicetype' = $DeviceType} | ConvertTo-Json
        $Result = Invoke-RestMethod -Uri $URI -Method Post -Body $Body -ContentType 'application/json' 
        
        If($null -ne $Result.Success.Username){

            $Properties = [ordered]@{'APIKey' = $Result.Success.Username}

            $obj = New-Object -TypeName psobject -Property $Properties
            Write-Output $obj

        }
    }
    catch{
        If($_ -match 'link button not pressed'){

            Write-Error "Gateway not unlocked. Go in to Settings->Gateway->Advanced and click on Authenticate app"
        }
        else{

            Write-Error $_
        }
    }
}
