# Description: This script demonstrates how to create a simple navigation menu in PowerShell.

# Get the current cursor position as a Coordinates object (X, Y) from the console.
function Get-CursorPosition {
    $x, $y = $Host.UI.RawUI.CursorPosition -split ',' # Split the cursor position into X and Y coordinates
    return @{x = $x; y = $y } # Return the cursor position as a hashtable
}

# Set the cursor position to the specified coordinates (X, Y) in the console.
function Set-CursorPosition {
    param (
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$X, # The X coordinate

        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$Y # The Y coordinate
    )

    # Set the cursor position to the specified coordinates
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates($X, $Y)
}

# Get the menu items from the specified file
function Get-MenuItems {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [string]$FilePath # The path to the file containing the menu items
    )
    $menuItems = Get-Content -Path $FilePath -ErrorAction Stop # Read the menu items from the specified file
    $selectedIndex = 0  # Default selected index is 0
    return @{MenuItems = $menuItems; SelectedIndex = $selectedIndex } # Return the menu items and the selected index
}

# Read the array of menu items and the selected index and display the menu
function Show-Menu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [array]$menuItems, # The array of menu items

        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$selectedIndex # The selected index
    )

    for ($i = 0; $i -lt $menuItems.Count; $i++) {
        if ($i -eq $selectedIndex) {
            $StartOfMenu = Get-CursorPosition
            Write-Host "-> " -ForegroundColor Cyan -NoNewline; Write-Host $($menuItems[$i])
        }
        else {
            Write-Host "   $($menuItems[$i])"
        }
    }
    return $StartOfMenu.Y
}

# Set the pointer display as per the menu
function Set-PointerDisplayAsPerMenu {
    param (
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [array]$menuItems, # The array of menu items

        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$selectedIndex # The selected index
    )

    for ($i = 0; $i -lt $menuItems.Count; $i++) {
        if ($i -eq $selectedIndex) {
            Write-Host "-> " -ForegroundColor Cyan
        }
        else {
            Write-Host "   "
        }
    }
}

# Get the key stroke from the user
function Get-KeyStroke {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") # Read the key stroke without echoing it to the console
    return $key # Return the key stroke
}

# Set the cursor position to the top of the menu
function Set-CursorPositionToTopOfMenu {
    param (
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$startOfmenu # The number of menu items
    )
    $cursorPosition = Get-CursorPosition # Get the current cursor position
    # Move the cursor up to the top of the menu
    $cursorPosition.Y = $startOfmenu
    # Set the cursor position to the top of the menu
    Set-CursorPosition -X $cursorPosition.X -Y $cursorPosition.Y
}

# Start the navigation menu
# The navigation menu is started with the specified menu items and selected index
function Start-Navigation {
    param (
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [array]$menuItems, # The array of menu items

        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$selectedIndex, # The selected index
        
        [Parameter(Mandatory = $true)] # Mandatory parameter
        [int]$startOfmenu # The selected index
        
        # [Parameter(Mandatory = $true)] # Mandatory parameter
        # [int]$endOfMenu # The selected index
    )

    $CPosition = Get-CursorPosition # Get the current cursor position
    [System.Console]::CursorVisible = $false # Hide the cursor
    
    # Loop until the user presses the Escape key
    while ($true) {
        $key = Get-KeyStroke # Get the key stroke from the user
        
        # Handle the key stroke
        if ($key.VirtualKeyCode -eq 13) {
            # 13 = Enter key
            Set-CursorPosition -X $CPosition.x -Y $CPosition.y # Set the cursor position to the current position
            # Write-Host "-> You selected $($menuItems[$selectedIndex])" # Display the selected menu item
            break # Exit the loop
        }
        elseif ($key.VirtualKeyCode -eq 38) {
            # 38 = Up arrow key
            # If the selected index is greater than 0, move the selection up
            if ($selectedIndex -gt 0) {
                # Move the selection up
                $selectedIndex-- # Decrement the selected index because the Up arrow key was pressed
                Set-CursorPositionToTopOfMenu -startOfmenu $startOfmenu # Set the cursor position to the top of the menu
                Set-PointerDisplayAsPerMenu -menuItems $menuItems -selectedIndex $selectedIndex # Display the menu with the new selected index
            }
        }
        elseif ($key.VirtualKeyCode -eq 40) {
            # 40 = Down arrow key
            if ($selectedIndex -lt ($menuItems.Count - 1)) {
                # Move the selection down
                $selectedIndex++ # Increment the selected index because the Down arrow key was pressed
                Set-CursorPositionToTopOfMenu -startOfmenu $startOfmenu # Set the cursor position to the top of the menu
                Set-PointerDisplayAsPerMenu -menuItems $menuItems -selectedIndex $selectedIndex # Display the menu with the new selected index
            }
        }
        # If the key stroke is the Escape key, exit the menu
        elseif ($key.VirtualKeyCode -eq 27) {
            # 27 = Escape key
            break # Exit the loop
        }
    }

    [System.Console]::CursorVisible = $true # Show the cursor
}

# Main script logic starts here
$menuData = Get-MenuItems -FilePath ".\NavigationMenu.txt" # Get the menu items from the specified file

Write-Host "Select an option:" # Display the menu title
# Clear-Host # Clear the console
$StartOfMenu = Show-Menu -menuItems $menuData.MenuItems -selectedIndex $menuData.SelectedIndex # Display the menu
Write-Host "Postion of 1st menu item: $($StartOfMenu)" # Display the position of the 1st menu item
Write-Host "Press Enter to select the menu item." # Prompt the user to press Enter to select a menu item
Write-Host "Press ESC to exit." # Prompt the user to press Enter to select a menu item
# $EndOfMenu = Get-CursorPosition
# Write-Host "EndOfMenu. x :  $($EndOfMenu.x) y : $($EndOfMenu.y)"
Start-Navigation -menuItems $menuData.MenuItems -selectedIndex $menuData.SelectedIndex -startOfmenu $StartOfMenu # Start the navigation menu
