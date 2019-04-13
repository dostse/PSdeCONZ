function Get-DeconzLight{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [string[]]$LightName
    )
    BEGIN{
    
        $FullURI = "$URI/$APIKey/"
    
    }
    PROCESS{

        if($PSBoundParameters.ContainsKey('LightName')){
            $Lights = ((Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json).psobject.properties | Where-Object {$_.value.Name -eq "$LightName"}
            }
        else{
            $Lights = ((Invoke-WebRequest -Uri "$($FullURI)lights").content | ConvertFrom-Json | Sort-Object).psobject.properties
        }  

        foreach($Light in $Lights){
    
            $Properties = [ordered]@{'Name' = $Light.Value.name
                                     'Manufacturer' = $Light.Value.manufacturername
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
