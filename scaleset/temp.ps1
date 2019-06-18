
$pwd1 = Read-Host "Password" -AsSecureString
$pwd2 = Read-Host "Re-enter Password" -AsSecureString
$pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
$pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
    

if ($pwd1_text -ceq $pwd2_text) {
    Write-Host "passwd goed"
} else {
    Write-Host "password error"
}