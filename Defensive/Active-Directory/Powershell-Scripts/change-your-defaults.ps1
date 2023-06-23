<#
    This is your warning: This can be destructive. Ensure that this does not break any service accounts, secret accounts, etc before running. 
    Your org may be set up differently, so edit the filter to account for those changes where necessary.

    This essentially takes the new-user-change-default script and all-users-password-reset script together.
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
            # Try to parse hiredate and PasswordLastSet as DateTime. If it fails, move on to the next user.
            try {
                $hiredate = [datetime]::Parse($_.hiredate)
                $passwordLastSet = [datetime]::Parse($_.PasswordLastSet)
            }
            catch {
                Write-Warning "Failed to parse hiredate or PasswordLastSet for user $($_.SamAccountName)"
                continue
            }
            # Next check to see if the password was set before their hiredate.
            if ($passwordLastSet -lt $hiredate) {
                Set-ADUser -Identity $_.SamAccountName -ChangePasswordAtLogon $true
                # Confirm that a user must change their password. Comment out to not get bombarded in large organizations.
                Write-Host "Set 'User must change password at next logon' for $($_.SamAccountName)"
            }
        }     
    }
}
