# Found an encrypted file and need to find the cert to decrypt it on a machine? Got you. Just provide the thumbprint and I'll find the cert for you - if it exists. 

# Prompt for the thumbprint securely
$thumbprint = Read-Host "Enter the certificate thumbprint" -AsSecureString

# Convert the secure string to plain text
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($thumbprint)
$thumbprint = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Remove any spaces from the thumbprint
$thumbprint = $thumbprint -replace '\s', ''

# Search for the certificate
$cert = Get-ChildItem -Path Cert:\ -Recurse | Where-Object { $_.Thumbprint -eq $thumbprint }

if ($cert) {
    Write-Output "Certificate found:"
    Write-Output "Subject: $($cert.Subject)"
    Write-Output "Issuer: $($cert.Issuer)"
    Write-Output "NotBefore: $($cert.NotBefore)"
    Write-Output "NotAfter: $($cert.NotAfter)"
    Write-Output "Store: $($cert.PSParentPath)"
}
else {
    Write-Output "Certificate with thumbprint $thumbprint not found."
}