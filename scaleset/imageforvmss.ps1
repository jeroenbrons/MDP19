# Get VM object
$vm = Get-AzVM -Name "eteqVMtemp" -ResourceGroupName "ETEQ"

# Create the VM image configuration based on the source VM
$image = New-AzImageConfig -Location "westeurope" -SourceVirtualMachineId $vm.ID 

# Create the custom VM image
New-AzImage -Image $image -ImageName "ETEQimg" -ResourceGroupName "ETEQ"