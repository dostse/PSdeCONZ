function Get-DeconzConfiguration{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    [string]$URI,
    [Parameter(Mandatory=$true)]
    [string]$APIKey
    )
       
    $FullURI = "$URI/$APIKey/"
    $Configuration = (Invoke-WebRequest -Uri "$($FullURI)config").content | ConvertFrom-Json | Sort-Object

    $Configuration


}
