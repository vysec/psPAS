﻿function Add-PASApplication{
<#
.SYNOPSIS
Adds a new application to the Vault
.DESCRIPTION
Adds a new application to the Vault.
Manage Users permission is required.

.PARAMETER AppID
The application name.
Must be fewer than 128 characters.
Cannot include ampersand ("&") character.
Can include "@" character, but any searches for applications cannot include 
this character.

.PARAMETER Description
Description of the application, no longer than 29 characters.

.PARAMETER Location
The location of the application in the vault hieracrchy.
Note: to insert a backslash in the location path, use a double backslash.

.PARAMETER AccessPermittedFrom
The start hour that access is permitted to the application.
Valid values are 0-23.

.PARAMETER AccessPermittedTo
The end hour that access to the application is permitted.
Valid values are 0-23.

.PARAMETER ExpirationDate
The date when the application expires.
Must be in format mm-dd-yyyy

.PARAMETER Disabled
Boolean value, denoting if the appication is disabled or not.

.PARAMETER BusinessOwnerFName
The first name of the business owner.
Specify up to 29 characters.

.PARAMETER BusinessOwnerLName
The last name of the business owner.

.PARAMETER BusinessOwnerEmail
The email address of the business owner

.PARAMETER BusinessOwnerPhone
The phone number of the business owner.
Specify up to 24 characters.

.PARAMETER sessionToken
Hashtable containing the session token returned from New-PASSession

.PARAMETER WebSession
WebRequestSession object returned from New-PASSession

.PARAMETER BaseURI
PVWA Web Address
Do not include "/PasswordVault/"

.EXAMPLE
.INPUTS
.OUTPUTS
.NOTES
.LINK
#>
    [CmdletBinding()]  
    param(
        [parameter(
            Mandatory=$true
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1,127)]
        [ValidateScript({$_ -notmatch ".*(\&).*"})]
        [string]$AppID,

        [parameter(
            Mandatory=$false
        )]
        [ValidateLength(0,29)]
        [string]$Description,

        [parameter(
            Mandatory=$true
        )]
        [string]$Location,

        [parameter(
            Mandatory=$false
        )]
        [ValidateRange(0,23)]
        [int]$AccessPermittedFrom,

        [parameter(
            Mandatory=$false
        )]
        [ValidateRange(0,23)]
        [int]$AccessPermittedTo,

        [parameter(
            Mandatory=$false
        )]
        [ValidateScript({if($_ -match '^(0[1-9]|1[0-2])[-](0[1-9]|[12]\d|3[01])[-]\d{4}$'){
        $true}Else{Throw "$_ must match pattern MM-DD-YYYY"}})]
        [string]$ExpirationDate,

        [parameter(
            Mandatory=$false
        )]
        [boolean]$Disabled,

        [parameter(
            Mandatory=$false
        )]
        [ValidateLength(0,29)]
        [string]$BusinessOwnerFName,

        [parameter(
            Mandatory=$false
        )]
        [string]$BusinessOwnerLName,

        [parameter(
            Mandatory=$false
        )]
        [int]$BusinessOwnerEmail,

        [parameter(
            Mandatory=$false
        )]
        [ValidateLength(0,24)]
        [int]$BusinessOwnerPhone,
          
        [parameter(
            Mandatory=$true,
            ValueFromPipelinebyPropertyName=$true
        )]
        [ValidateNotNullOrEmpty()]
        [hashtable]$sessionToken,

        [parameter(
            ValueFromPipelinebyPropertyName=$true
        )]
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,

        [parameter(
            Mandatory=$true,
            ValueFromPipelinebyPropertyName=$true
        )]
        [string]$BaseURI

    )

    BEGIN{}#begin

    PROCESS{

        #WebService URL
        $URI = "$baseURI/PasswordVault/WebServices/PIMServices.svc/Applications"

        #Create Request Body
        $body = @{
                    "application" = $PSBoundParameters | Get-PASParameters

                } | ConvertTo-Json
        
        #Send Request
        Invoke-PASRestMethod -Uri $URI -Method POST -Body $Body -Headers $sessionToken -WebSession $WebSession

    }#process

    END{}#end
}