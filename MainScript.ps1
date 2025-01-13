# MainScript.ps1
# Import the modules
Write-Host -Object "Importing all modules from $("$PSScriptRoot\Modules\AllModules.psm1")"
Import-Module -Name "$PSScriptRoot\Modules\AllModules.psm1"

Write-Host -Object "Loading menu from `"$PSScriptRoot\NavigationMenu.txt`""
$menuData = Get-MenuItems -FilePath ".\NavigationMenu.txt"

# Clear-Host
Clear-Host

Show-Menu -menuItems $menuData.MenuItems -selectedIndex $menuData.SelectedIndex
Start-Navigation -menuItems $menuData.MenuItems -selectedIndex $menuData.SelectedIndex
