function Remove-DeconzAPIKey{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true)]
    [string[]]$APIKeyToRemove,
    [Parameter(Mandatory=$false)]
    [switch]$Force
    )
    BEGIN{
        
        $FullURI = "$URI/$APIKey/config/whitelist"

    }
    PROCESS{

        try{
            
            if ($Force -or $PSCmdlet.ShouldProcess($APIKeyToRemove)){
                
                $APKIKeyConfigURI = "$($FullURI)/$($APIKeyToRemove)"
               
                Invoke-RestMethod -Uri $APKIKeyConfigURI -Method Delete | Out-Null

            }
        }
        catch{
        
            Write-Error $_.Exception
        }    
    }
    END{}
}
