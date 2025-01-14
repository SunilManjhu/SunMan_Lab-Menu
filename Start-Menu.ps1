# Description: This script demonstrates how to create a simple navigation menu in PowerShell.

# Read menu items from a file and return them as an array
# The file should contain one menu item per line
# The selected index is set to 0
# The menu items are returned as an array of strings
# The selected index is returned as an integer
# The selected index is used to indicate the currently selected menu item
# The selected index is used to navigate the menu
function Get-MenuItems {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    $menuItems = Get-Content -Path $FilePath
    $selectedIndex = 0
    return @{MenuItems = $menuItems; SelectedIndex = $selectedIndex }
}

# Read the array of menu items and the selected index and display the menu
# with the selected index highlighted
# The selected index is indicated by an arrow (->) before the menu item
# The selected index is indicated by a different color (Cyan) for the menu item
# The other menu items are displayed in the default color
# The menu items are displayed in the order they appear in the array
# The selected index is displayed at the top of the menu
# The menu items are displayed one per line
# The menu items are displayed with a leading space to align them with the selected index
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

# Get the key stroke from the user
# The key stroke is read without echoing it to the console
# The key stroke is read including the key down event
# The key stroke is returned as a KeyInfo object
# The key stroke is used to navigate the menu
# The key stroke is used to exit the menu
function Get-KeyStroke {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    return $key
}

# Get the current cursor position
# The cursor position is returned as a Coordinates object
# The cursor position is used to navigate the menu
function Get-CursorPosition {
    $CursorPosition = $Host.UI.RawUI.CursorPosition
    return $CursorPosition
}

# Set the cursor position to the specified coordinates
# The cursor position is set to the specified coordinates
# The cursor position is used to navigate the menu
# The cursor position is used to display the menu
# The cursor position is used to highlight the selected index
# The cursor position is used to indicate the currently selected menu item
# The cursor position is used to indicate the arrow (->) before the menu item
# The cursor position is used to indicate the different color (Cyan) for the menu item
function Set-CursorPosition {
    param (
        [Parameter(Mandatory = $true)]
        [int]$X,

        [Parameter(Mandatory = $true)]
        [int]$Y
    )

    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($X, $Y)
}

# Start the navigation menu
# Function to set the cursor position to the first line of the menu
# It doesn't clear the screen and starts from whereever the first line of the menu is displayed
# when down arrow is pressed it doesn't create menu again but just moves the cursor to the next line of existing displayed menu
# When exit key is pressed it clears the screen and exits
# Hides the cursor
function Start-Navigation {
    param (
        [Parameter(Mandatory = $true)]
        [array]$menuItems,

        [Parameter(Mandatory = $true)]
        [int]$selectedIndex
    )

    $cursorPosition = Get-CursorPosition
    $cursorPosition.Y = $cursorPosition.Y - $menuItems.Count
    Set-CursorPosition -X $cursorPosition.X -Y $cursorPosition.Y

    $Host.UI.RawUI.CursorVisible = $false

    while ($true) {
        $key = Get-KeyStroke

        if ($key.VirtualKeyCode -eq 38) {
            if ($selectedIndex -gt 0) {
                $selectedIndex--
                Set-CursorPosition -X $cursorPosition.X -Y ($cursorPosition.Y + 1)
                Show-Menu -menuItems $menuItems -selectedIndex $selectedIndex
            }
        }
        elseif ($key.VirtualKeyCode -eq 40) {
            if ($selectedIndex -lt ($menuItems.Count - 1)) {
                $selectedIndex++
                Set-CursorPosition -X $cursorPosition.X -Y ($cursorPosition.Y + 1)
                Show-Menu -menuItems $menuItems -selectedIndex $selectedIndex
            }
        }
        elseif ($key.VirtualKeyCode -eq 27) {
            Clear-Host
            break
        }
    }

    $Host.UI.RawUI.CursorVisible = $true
}

# MainScript.ps1
$menuData = Get-MenuItems -FilePath ".\NavigationMenu.txt"

# Clear-Host
# Clear-Host

Show-Menu -menuItems $menuData.MenuItems -selectedIndex $menuData.SelectedIndex
Start-Navigation -menuItems $menuData.MenuItems -selectedIndex $menuData.SelectedIndex
