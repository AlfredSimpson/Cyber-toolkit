<# 
    Sometimes users don't change their default passwords.
    This will scan for all users in AD who have a hiredate more recent than their password was last set.
    This implies that their password was set before they were hired and is likely to be a default password.

    NOTE: This only generates a list of the users and outputs them as a CSV. Another powershell script, change-your-defaults.ps1, will force all users within the same criteria to update their passwords.
    I separated these as doing so may be destructive. Always confirm that service accounts and any other type your organization uses may not be affected by this.
    Setting password change compliance through a third party such as Okta or OneLogin is a better method to prevent future issues, but this may act as remediation and as a way to check for compliance.
#>

# Import the AD Module if it's not already loaded
if (-not (Get-Module ActiveDirectory)) {
    Import-Module ActiveDirectory
}

# Get all add users who are active (enabled), their hiredate (your org may list this differently), PasswordLastSet (the time they last changed their password)
Get-ADUser -Filter * -Property SamAccountName, enabled, hiredate, PasswordLastSet | ForEach-Object {
    # Check first that they are active
    if ($_.enabled) {
        # Check if the hiredate and PasswordLastSet are not null
        if ($_.hiredate -and $_.PasswordLastSet) {
            # Convert the hiredate and PasswordLastSet to datetime object for comparison
            $hiredate = [datetime]::Parse($_.hiredate)
            $passwordLastSet = [datetime]::Parse($_.PasswordLastSet)
            # Next check to see if the password was set before their hiredate.
            if ($passwordLastSet -lt $hiredate) {
                New-Object PSObject -Property @{
                    SamAccountName  = $_.SamAccountName
                    hiredate        = $hiredate
                    PasswordLastSet = $passwordLastSet
                }
            }
        }
    }
} | Export-Csv -NoTypeInformation -Path users-not-updated.csv #Export users not updated
