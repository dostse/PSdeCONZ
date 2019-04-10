function Set-DeconzLightPowerState{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string[]]$LightName,
    [Parameter(Mandatory=$true)]
    [ValidateSet('on','off')]
    [string]$State 
    )
    BEGIN{
    
        $FullURI = "$URI/$APIKey/"

    }
    PROCESS{
        
        
        $Light = ((Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$LightName"}

        Switch ( $State )
        {
            'on' { $LightState = $true    }
            'off' { $LightState = $false    }
        }
        try{
            if ($Force -or $PSCmdlet.ShouldProcess($LightName,"Changing PowerState to $State.")){
                $Actions = @{
                            'on'=$LightState
                            }
                $LightURI = "$FullURI/lights/$($Light.Value.uniqueid)/state"
                $Result = Invoke-RestMethod -Uri $LightURI -Method Put -Body ($Actions | ConvertTo-Json) -ContentType 'application/json'
            }
        }
        catch{
            Write-Error $_.Exception
        }
    }
    END{}
}
