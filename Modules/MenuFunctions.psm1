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
