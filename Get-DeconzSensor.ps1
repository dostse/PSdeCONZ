function Get-DeconzSensor{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [string[]]$SensorName 
    )
    BEGIN{
            
        $FullURI = "$URI/$APIKey/"

    }
    PROCESS{

        if($PSBoundParameters.ContainsKey('SensorName')){
            $Sensors = ((Invoke-WebRequest -Uri "$($FullURI)sensors").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$SensorName"}
            }
        else{
            $Sensors = ((Invoke-WebRequest -Uri "$($FullURI)sensors").content | ConvertFrom-Json | Sort-Object).psobject.properties
        }  


        foreach($Sensor in $Sensors){

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