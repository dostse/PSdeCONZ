function Set-DeconzLightPowerState{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
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
    
        $FullURI = "$URI/$APIKey"

        Switch ( $State )
        {
            'on' { $LightState = $true    }
            'off' { $LightState = $false    }
        }

    }
    PROCESS{
        
        $Light = ((Invoke-WebRequest -Uri "$($FullURI)/lights").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$LightName"}

        try{
            if ($Force -or $PSCmdlet.ShouldProcess($LightName,"Changing PowerState to $State.")){
                
                $Actions = @{'on'=$LightState}

                $LightURI = "$FullURI/lights/$($Light.Value.uniqueid)/state"
                
                Invoke-RestMethod -Uri $LightURI -Method Put -Body ($Actions | ConvertTo-Json) -ContentType 'application/json' | Out-Null
            }
        }
        catch{
            Write-Error $_.Exception
        }
    }
    END{}
}
