#az vm deallocate --resource-group ETEQ --name eteqVMtemp
#az vm generalize --resource-group ETEQ --name eteqVMtemp


Stop-AzVM -ResourceGroupName "ETEQ" -Name "eteqVMtemp" -Force
Set-AzVM -ResourceGroupName "ETEQ" -Name "eteqVMtemp" -Generalized