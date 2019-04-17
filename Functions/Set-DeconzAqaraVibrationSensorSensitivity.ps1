
function Set-DeconzAqaraVibrationSensorSensitivity{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string[]]$SensorName,
    [Parameter(Mandatory=$true)]
    [Int][ValidateRange(1,21)]$Sensitivity,
    [Parameter(Mandatory=$false)]
    [switch]$Force 
    )
    BEGIN{
        
        $FullURI = "$URI/$APIKey"

    }
    PROCESS{

        try{
            $Sensors = ((Invoke-WebRequest -Uri "$($FullURI)/sensors").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$SensorName" -and $_.value.modelid -eq 'lumi.vibration.aq1'}
            
            if($Sensors.Count -lt 1){

                Write-Error -Message 'Sensor(s) is not an Aqara Vibration sensor.'
            }

            if ($Force -or $PSCmdlet.ShouldProcess($SensorName,"Changing sensitivity to $Sensitivity.")){
                
                foreach($Sensor in $Sensors){
                    $SensorConfigURI = "$($FullURI)/sensors/$($Sensor.Value.uniqueid)/config"
                    
                    $Config = @{'sensitivity'=$Sensitivity}
                
                    Invoke-RestMethod -Uri $SensorConfigURI -Method Put -Body ($Config | ConvertTo-Json) -ContentType 'application/json' | Out-Null
                }
            }
        }
        catch{
        
            Write-Error $_.Exception
        }    
    }
    END{}
}