function Set-DeconzMotionSensorDuration{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string[]]$SensorName,
    [Parameter(Mandatory=$true)]
    [Int][ValidateRange(1,600)]$Duration,
    [Parameter(Mandatory=$false)]
    [switch]$Force 
    )
    BEGIN{
        
        $FullURI = "$URI/$APIKey/"

    }
    PROCESS{
        try{
            $Sensor = ((Invoke-WebRequest -Uri "$($FullURI)sensors").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$SensorName"}
            if ($Force -or $PSCmdlet.ShouldProcess($SensorName,"Changing Duration to $Duration seconds.")){
                $SensorConfigURI = "$($FullURI)sensors/$($Sensor.Value.uniqueid)/config"
                $Config = @{'duration'=$Duration}
               
                $Result = Invoke-RestMethod -Uri $SensorConfigURI -Method Put -Body ($Config | ConvertTo-Json) -ContentType 'application/json'

            }
        }
        catch{
        
            Write-Error $_.Exception
        }    
    }
    END{}
}
