<# 
    PLEASE NOTE:

    This is potentially destructive and all ADs might be built differently.  You'll want to confirm that this will not break any service accounts or secret accounts first.
    This script will require ALL USERS TO CHANGE THEIR PASSWORD WHEN THEY NEXT LOGON.

    Again - this will affect all users in AD and is a script to force password changes at next logon in the event of a compromise.
    
#>

# Import the AD Module if it's not already loaded
if (-not (Get-Module ActiveDirectory)) {
    Import-Module ActiveDirectory
}

# Get all of the users in your Active Directory

$users = Get-ADUser -Filter * -Property SamAccountName

# Iterate through each user

foreach ($user in $users) {
    # Set the 'User must change password at next logon' flag to rue
    Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
    # Confirm that a user must change their password. Comment out to not get bombarded in large organizations.
    Write-Host "Set 'User must change password at next logon' for $($user.SamAccountName)"
}

# Output completion message
Write-Host "All users have been updated!"