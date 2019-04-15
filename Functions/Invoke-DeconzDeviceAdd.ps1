# Work in progress, needs more testing and progress + results

function Invoke-DeconzDeviceAdd{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true)]
    [ValidateSet('Lights','Sensors')]
    [string]$Type
    )
       
    Try{

        $FullURI = "$URI/$APIKey/$($Type.ToLower())"

        $Result = Invoke-RestMethod -Uri $FullURI -Method Post -Body $Header -ContentType 'application/json' 
        
        $Result


    }
    catch{

        Write-Error $_
    }
    
}
