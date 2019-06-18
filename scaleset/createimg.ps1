$resourceGroupName = 'ETEQ' 
$location = 'westeurope' 
$vmName = 'eteqVMtemp'
$snapshotName = 'prep1'  
$vm = get-azvm -ResourceGroupName $resourceGroupName -Name $vmName
$snapshot =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location -CreateOption copy
New-AzSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 