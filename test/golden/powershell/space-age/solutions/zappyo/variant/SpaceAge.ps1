Function Get-SpaceAge() {
    <#
    .SYNOPSIS
    Given an age in seconds, calculate how old someone would be on a planet in the solar system. (RIP Pluto)
    
    .DESCRIPTION
    The function takes a positive integer, and return a double (float) to show how old someone is on a specific planet.

    .PARAMETER $Seconds
    The seconds of a person's age.

    .PARAMETER $Planet
    The planet to calculate how old the person would be on it.
    Note: Since the planets in the solar system is a known shortlist, we can just validate the input with a set of values in the params.
    If no planet is specified, it should be default to Earth.
    
    .EXAMPLE
    Get-SpaceAge -Seconds 1000000000 -Planet Neptune
    Retuns: 0.19
    #>
    [CmdletBinding()]
    Param(
        [int]$Seconds,
        [string]$Planet
    )

    
    switch($Planet){
        "Mercury" {Return [Math]::Round($Seconds/(31557600*0.2408467), 2)}
        "Venus" {Return [Math]::Round($Seconds/(31557600*0.61519726),3)}
        "Earth" {Return [Math]::Round($Seconds/(31557600),2)}
        "Mars" {Return [Math]::Round($Seconds/(31557600*1.8808158),2)}
        "Jupiter" {Return [Math]::Round($Seconds/(31557600*11.862615),2)}
        "Saturn" {Return [Math]::Round($Seconds/(31557600*29.447498),2)}
        "Uranus" {Return [Math]::Round($Seconds/(31557600*84.016846),2)}
        "Neptune" {Return [Math]::Round($Seconds/(31557600*164.79132),2)}
        default {if($Planet.Length -gt 0){
            Throw "Invalid planet"
        }Return [Math]::Round($Seconds/(31557600),2)}
    }
}