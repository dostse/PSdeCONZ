function Set-DeconzIKEALightColor{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string[]]$LightName,
    [Parameter(Mandatory=$true)]
    [ValidateSet('Blue','Green','Orange','Polar','Pink','Plum','Purple','Red','White','WhiteWarm','WhiteCold','Yellow')]
    [string]$Color,
    [Parameter(Mandatory=$false)]
    [Int][ValidateRange(1,254)]$Brightness
    )
    BEGIN{
    
        $FullURI = "$URI/$APIKey/"
        
        Switch ( $Color ) {
            
            'Blue' { 
                    $Actions = @{'xy' = 0.135988,0.0399939}
                   }
            'Green' { 
                    $Actions = @{'xy' = 0.3760,0.5220}
                   }
            'Orange' { 
                    $Actions = @{'xy' = 0.611994,0.373999}
                   }
            'Polar' { 
                    $Actions = @{'xy' = 0.2952,0.3207}
                   }
            'Pink' { 
                    $Actions = @{'xy' = 0.384985,0.154986}
                   }
            'Plum' { 
                    $Actions = @{'xy' = 0.3352,0.1837}
                   }
            'Purple' { 
                    $Actions = @{'xy' = 0.2253,0.1713}
                   }
            'Red' { 
                    $Actions = @{'xy' = 0.700999,0.298985}
                   }
            'White' { 
                    $Actions = @{'xy' = 0.3544,0.3746}
                   }
            'WhiteWarm' { 
                    $Actions = @{'xy' = 0.4021,0.4273}
                   }
            'WhiteCold' { 
                    $Actions = @{'xy' = 0.3119,0.3329}
                   }
            'Yellow' { 
                    $Actions = @{'xy' = 0.443992,0.516991}
                   }
        }
    }
    PROCESS{
       
        $Light = ((Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$LightName"}
       
        try{
            if($Light.Value.Type -ne 'Color Light' -and $Light.Value.Manufacturer -ne 'IKEA of Sweden'){
                throw 'Light is not and IKEA CWS Light.'
            }
            if ($Force -or $PSCmdlet.ShouldProcess($LightName,"Changing Color to $Color.")){
                
                $LightURI = "$FullURI/lights/$($Light.Value.uniqueid)/state"
                $Result = Invoke-RestMethod -Uri $LightURI -Method Put -Body ($Actions | ConvertTo-Json) -ContentType 'application/json'

                if($PSBoundParameters.ContainsKey('Brightness')){
                    # Sleep - If you change the xy and brightness directly after eachother the bri does not take.
                    Start-Sleep -Seconds 1
                    $Actions = @{'bri' = $Brightness}
                    $Result = Invoke-RestMethod -Uri $LightURI -Method Put -Body ($Actions | ConvertTo-Json) -ContentType 'application/json'
                }
            }
        }
        catch{
            Write-Error $_.Exception
        }
    }
    END{}
}