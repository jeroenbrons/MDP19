$pwd1 = Read-Host "Password" -AsSecureString
$pwd2 = Read-Host "Re-enter Password" -AsSecureString
$pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
$pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
    

if ($pwd1_text -ceq $pwd2_text) {
    Write-Host "passwd goed"
    $vmPassword = ConvertTo-SecureString $password -AsPlainText -Force
    $vmCred = New-Object System.Management.Automation.PSCredential("eteqadmin", $vmPassword)
    New-AzVmss `
        -Credential $vmCred `
        -ResourceGroupName "ETEQ" `
        -Location "westeurope" `
        -VMScaleSetName "ETEQODOOScaleSet" `
        -VirtualNetworkName "ETEQ" `
        -SubnetName "eteqodoonet" `
        -PublicIpAddressName "eteqVMtemp-ipnew" `
        -LoadBalancerName "ETEQLB" `
        -UpgradePolicyMode "Automatic" `
        -ImageName "ETEQimg"
} else {
    Write-Host "password error"
}