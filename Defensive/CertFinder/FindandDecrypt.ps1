# This Expands upon certfinder. It will scan the computer for the cert, and if found, will prompt for the encrypted file and output the decrypted file as output. Should help decrypt files if the certs are lying around... hopefully. 
#
# Prompt for the thumbprint securely
$thumbprint = Read-Host "Enter the certificate thumbprint" -AsSecureString

# Convert the secure string to plain text
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($thumbprint)
$thumbprint = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Remove any spaces from the thumbprint
$thumbprint = $thumbprint -replace '\s', ''

# Search for the certificate
$cert = Get-ChildItem -Path Cert:\ -Recurse | Where-Object { $_.Thumbprint -eq $thumbprint } | Select-Object -First 1

if ($cert) {
    Write-Output "Certificate found:"
    Write-Output "Subject: $($cert.Subject)"
    Write-Output "Issuer: $($cert.Issuer)"
    Write-Output "NotBefore: $($cert.NotBefore)"
    Write-Output "NotAfter: $($cert.NotAfter)"
    Write-Output "Store: $($cert.PSParentPath)"

    # Prompt for the encrypted file path
    $encryptedFilePath = Read-Host "Enter the path to the encrypted file"

    # Prompt for the output file path
    $decryptedFilePath = Read-Host "Enter the path for the decrypted output file"

    try {
        # Read the encrypted content
        $encryptedBytes = [System.IO.File]::ReadAllBytes($encryptedFilePath)

        # Decrypt the content
        $rsaProvider = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($cert)
        $decryptedBytes = $rsaProvider.Decrypt($encryptedBytes, [System.Security.Cryptography.RSAEncryptionPadding]::OaepSHA256)

        # Write the decrypted content to the output file
        [System.IO.File]::WriteAllBytes($decryptedFilePath, $decryptedBytes)

        Write-Output "File decrypted successfully."
    }
    catch {
        Write-Error "An error occurred during decryption: $_"
    }
}
else {
    Write-Output "Certificate with thumbprint $thumbprint not found."
}
