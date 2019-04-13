function Set-DeconzLightBrightness{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string[]]$LightName,
    [Parameter(Mandatory=$true)]
    [Int][ValidateRange(1,254)]$Brightness
    )
    BEGIN{
    
        $FullURI = "$URI/$APIKey/"
        
    }
    PROCESS{
        
        
        $Light = ((Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$LightName"}

        try{
            if($Light.Value.State -notmatch 'bri='){
                throw 'Light is not dimmable.'
            }
            if ($Force -or $PSCmdlet.ShouldProcess($LightName,"Changing Color to $Color.")){
                
                $LightURI = "$FullURI/lights/$($Light.Value.uniqueid)/state"

                $Actions = @{'bri' = $Brightness}
                
                $Result = Invoke-RestMethod -Uri $LightURI -Method Put -Body ($Actions | ConvertTo-Json) -ContentType 'application/json'
                
            }
        }
        catch{
            Write-Error $_.Exception
        }
    }
    END{}
}