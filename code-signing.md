# PowerShell Code Signing

Before you begin you need to either disable a lot of security settings in Windows related to [PowerShell execution policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
or ensure that you can locally sign the files you want to run. This is especially important on Windows 11 where the
defaults are even stricter than before.

> _NOTE:_ Yes, it is possible to run unsigned scripts by manually enabling these on a case by case basis as described in
> the section called "Running unsigned scripts using the RemoteSigned execution policy" of the aforementioned resource.
> If you want to go that way, you can skip the document contents below and use the `Unblock-File` cmdlet instead.

Script signing is fairly straightforward unless you want to sign the scripts on a different machine than you want to run
them on. As described by [Microsoft](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_signing)
you can self-sign scripts to run them locally.

## Creating the Signing Certificate

```powershell
$cert = New-SelfSignedCertificate -FriendlyName "Local PowerShell Code Signing Cert" `
  -Subject "Local PowerShell Code Signing Cert for $Env:UserName" `
  -CertStoreLocation Cert:\CurrentUser\My -Type CodeSigningCert
```

For the certificate to be fully accepted by the PC you are own and not generate any errors during signing or
verification it needs to be added to the appropriate trust stores:

```powershell
# Add the self-signed Authenticode certificate to the computer's root certificate store.
## Create an object to represent the LocalMachine\Root certificate store.
$rootStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root","LocalMachine")
## Open the root certificate store for reading and writing.
$rootStore.Open("ReadWrite")
## Add the certificate stored in the $authenticode variable.
$rootStore.Add($cert)
## Close the root certificate store.
$rootStore.Close()

# Add the self-signed Authenticode certificate to the computer's trusted publishers certificate store.
## Create an object to represent the LocalMachine\TrustedPublisher certificate store.
$publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("TrustedPublisher","LocalMachine")
## Open the TrustedPublisher certificate store for reading and writing.
$publisherStore.Open("ReadWrite")
## Add the certificate stored in the $authenticode variable.
$publisherStore.Add($cert)
## Close the TrustedPublisher certificate store.
$publisherStore.Close()
```

## Retrieving and Using the Signing Certificate

You can now run the following to sign the files you want.

```powershell
$filePath = "path to file"
Set-AuthenticodeSignature -Certificate $cert -TimeStampServer http://timestamp.digicert.com -FilePath $filePath
```

In case you need to retrieve the signing certificate again run:

```powershell
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert `
  | Where-Object {$_.Subject -eq "CN=Local PowerShell Code Signing Cert for $Env:UserName"} `
  | Select-Object -First 1
```

To check the signature you can invoke:

```powershell
Get-AuthenticodeSignature -FilePath $filePath | Select-Object -Property *
```

## Further Reading

For more information on code signing as well as options for universally accepted certificates, in particular when for
being able to share signed certificates have a look at the following resources:

- [How to Sign PowerShell Script](https://adamtheautomator.com/how-to-sign-powershell-script/)
- [sigstore](https://docs.sigstore.dev/)
- [SignPath](https://about.signpath.io/)
- [A guide to code signing certificates for the Microsoft app store and a question for the experts](https://old.reddit.com/r/electronjs/comments/17sizjf/a_guide_to_code_signing_certificates_for_the/)
- [Manage code signing certificates](https://learn.microsoft.com/en-us/windows-hardware/drivers/dashboard/code-signing-cert-manage)
