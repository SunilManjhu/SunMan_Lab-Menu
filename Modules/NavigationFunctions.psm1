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
