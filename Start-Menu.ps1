# MenuFunctions.psm1
function Get-MenuItems {
    # Parameter help description
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    Write-Host "$FilePath : $($FilePath)"
    $menuItems = Get-Content -Path $FilePath
    $selectedIndex = 0
    return @{MenuItems = $menuItems; SelectedIndex = $selectedIndex }
}

function Show-Menu {
    param (
        [Parameter(Mandatory = $true)]
        [array]$menuItems,

        [Parameter(Mandatory = $true)]
        [int]$selectedIndex
    )

    for ($i = 0; $i -lt $menuItems.Count; $i++) {
        if ($i -eq $selectedIndex) {
            Write-Host "-> $($menuItems[$i])" -ForegroundColor Cyan
        }
        else {
            Write-Host "   $($menuItems[$i])"
        }
    }
}


# NavigationFunctions.psm1
function Get-KeyStroke {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    return $key
}

function Start-Navigation {
    param (
        [Parameter(Mandatory = $true)]
        [array]$menuItems,

        [Parameter(Mandatory = $true)]
        [int]$selectedIndex
    )

    [System.Console]::CursorVisible = $false
    
    while ($true) {
        $key = Get-KeyStroke
        
        if ($key.VirtualKeyCode -eq 27) {
            Clear-Host
            Write-Host "Exiting menu..." -ForegroundColor Red
            break
        }
    
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, $selectedIndex)
        Write-Host "   $($menuItems[$selectedIndex])" 

        if ($key.VirtualKeyCode -eq 38) {
            $selectedIndex = ($selectedIndex - 1 + $menuItems.Count) % $menuItems.Count
        }
        elseif ($key.VirtualKeyCode -eq 40) {
            $selectedIndex = ($selectedIndex + 1) % $menuItems.Count
        }
        elseif ($key.VirtualKeyCode -eq 13) {
            Clear-Host
            Write-Host "You selected: $($menuItems[$selectedIndex])"
            Start-Sleep 1
            break
        }

        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, $selectedIndex)
        Write-Host "-> $($menuItems[$selectedIndex])" -ForegroundColor Green
    }
}


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
