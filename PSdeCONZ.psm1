function Get-DeconzSensor{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string[]]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey
    )
    BEGIN{}
    PROCESS{
        
        $FullURI = "$URI/$APIKey/"
        $Sensors = (Invoke-WebRequest -Uri "$($FullURI)sensors").content | ConvertFrom-Json | sort


        foreach($Sensor in $Sensors.psobject.properties){

            $Group = ((Invoke-WebRequest -Uri "$($FullURI)groups/$($Sensor.Value.config.group)").content | ConvertFrom-Json).Name
    
            $Properties = [ordered]@{'Name' = $Sensor.Value.name
                                     'Manufacurer' = $Sensor.Value.manufacturername
                                     'ModelID' = $Sensor.Value.modelid
                                     'UniqueID' = $Sensor.Value.uniqueid
                                     'Type' = $Sensor.Value.type
                                     'Firmware' = $Sensor.Value.swversion
                                     'Battery' = $Sensor.Value.config.battery
                                     'On' = $Sensor.Value.config.on
                                     'Reachable' = $Sensor.Value.config.reachable
                                     'Group' = $Group
                                     'LastUpdated' = $Sensor.Value.state.lastupdated
                                     'Config' = $Sensor.Value.config
                                     'State' = $Sensor.Value.state
            }

            $obj = New-Object -TypeName psobject -Property $Properties
            Write-Output $obj
        }
    }
    END{}
}

function Get-DeconzLight{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string[]]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey
    )
    BEGIN{}
    PROCESS{
        
        $FullURI = "$URI/$APIKey/"
        $Lights = (Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json | sort


        foreach($Light in $Lights.psobject.properties){

    
            $Properties = [ordered]@{'Name' = $Light.Value.name
                                     'Manufacurer' = $Light.Value.manufacturername
                                     'ModelID' = $Light.Value.modelid
                                     'UniqueID' = $Light.Value.uniqueid
                                     'Type' = $Light.Value.type
                                     'Firmware' = $Light.Value.swversion
                                     'On' = $Light.Value.State.on
                                     'Brightness' = $Light.Value.State.bri
                                     'HasColor' = $Light.Value.Hascolor
                                     'Reachable' = $Light.Value.state.reachable
                                     'State' = $Light.Value.state
            }

            $obj = New-Object -TypeName psobject -Property $Properties
            Write-Output $obj
        }
    }
    END{}
}

function Set-DeconzLightPowerState{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string[]]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true)]
    [string]$LightName,
    [Parameter(Mandatory=$true)]
    [ValidateSet('on','off')]
    [string]$State 
    )
    BEGIN{}
    PROCESS{
        
        $FullURI = "$URI/$APIKey/"
        $Lights = (Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json
        
        Switch ( $State )
        {
            'on' { $LightState = $true    }
            'off' { $LightState = $false    }
        }


        foreach($Light in $Lights.psobject.properties){
            if($Light.Value.Name -eq $LightName){
                $Actions = @{
                            'on'=$LightState
                            }
                $LightURI = "$FullURI/lights/$($Light.Value.uniqueid)/state"
                Invoke-RestMethod -Uri $LightURI -Method Put -Body ($Actions | ConvertTo-Json) -ContentType 'application/json'

            }
        }

    }
    END{}
}
