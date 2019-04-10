function Get-DeconzConfiguration{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$false)]
    [switch]$Force 
    )
       
    $FullURI = "$URI/$APIKey/"
    $Configuration = (Invoke-WebRequest -Uri "$($FullURI)config").content | ConvertFrom-Json | Sort-Object

    $Configuration


}
