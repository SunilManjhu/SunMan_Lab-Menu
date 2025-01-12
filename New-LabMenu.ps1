# Define folder path for JSON files
$folderPath = ".\Menu-Templates"  # This assumes the folder is in the same directory as the script

# Load JSON files for New Domain and Modify Domain options
$newDomainOptionsPath = Join-Path -Path $folderPath -ChildPath "newDomainOptions.json"
$modifyDomainOptionsPath = Join-Path -Path $folderPath -ChildPath "modifyDomainOptions.json"

# Function to load options from JSON file
function Load-JsonOptions {
    param (
        [string]$filePath
    )
    if (Test-Path $filePath) {
        $jsonContent = Get-Content -Path $filePath -Raw
        return $jsonContent | ConvertFrom-Json
    } else {
        Write-Host "Error: File not found at path $filePath" -ForegroundColor Red
        return $null  # Return null if the file doesn't exist
    }
}

# Load the options from the JSON files
$newDomainOptions = Load-JsonOptions -filePath $newDomainOptionsPath
$modifyDomainOptions = Load-JsonOptions -filePath $modifyDomainOptionsPath

# Check if either JSON file is missing or empty
if ($newDomainOptions -eq $null -or $modifyDomainOptions -eq $null) {
    Write-Host "Error: One or both of the JSON files are missing or empty. Exiting..." -ForegroundColor Red
    exit 1
}

# The rest of the menu script remains the same as before...
$currentSelection = 0
$history = @()

# Define main menu options
$options = @(
    "Create a New Domain",
    "Modify Existing Domains",
    "Other Options",  # This will now be handled
    "Exit"
)

# Function to display the main menu with history
function Show-Menu {
    param ([int]$currentSelection)
    
    Clear-Host
    Write-Host "==================== History ====================" -ForegroundColor Yellow
    if ($history.Count -gt 0) {
        Write-Host "Path: $($history -join ' > ')" -ForegroundColor Cyan
    } else {
        Write-Host "Path: (No History)" -ForegroundColor Red
    }
    Write-Host ""

    Write-Host "==================== Main Menu ====================" -ForegroundColor Yellow
    for ($i = 0; $i -lt $options.Length; $i++) {
        if ($i -eq $currentSelection) {
            Write-Host ">> $($options[$i])" -ForegroundColor Cyan
        } else {
            Write-Host "   $($options[$i])"
        }
    }
}

# Function to display the New Domain Wizard menu
function Show-NewDomainWizard {
    param ([int]$currentSelection)
    
    Clear-Host
    Write-Host "==================== History ====================" -ForegroundColor Yellow
    Write-Host "Path: $($history -join ' > ')" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "=== New Domain Wizard ===" -ForegroundColor Yellow
    for ($i = 0; $i -lt $newDomainOptions.Length; $i++) {
        if ($i -eq $currentSelection) {
            Write-Host ">> $($newDomainOptions[$i])" -ForegroundColor Cyan
        } else {
            Write-Host "   $($newDomainOptions[$i])"
        }
    }
}

# Function to display the Modify Existing Domains menu
function Show-ModifyDomainWizard {
    param ([int]$currentSelection)
    
    Clear-Host
    Write-Host "==================== History ====================" -ForegroundColor Yellow
    Write-Host "Path: $($history -join ' > ')" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "=== Modify Existing Domains ===" -ForegroundColor Yellow
    for ($i = 0; $i -lt $modifyDomainOptions.Length; $i++) {
        if ($i -eq $currentSelection) {
            Write-Host ">> $($modifyDomainOptions[$i])" -ForegroundColor Cyan
        } else {
            Write-Host "   $($modifyDomainOptions[$i])"
        }
    }
}

# Function to display the Other Options menu
function Show-OtherOptions {
    Clear-Host
    Write-Host "==================== History ====================" -ForegroundColor Yellow
    Write-Host "Path: $($history -join ' > ')" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "=== Other Options ===" -ForegroundColor Yellow
    Write-Host "This is a placeholder for any other menu items or actions you want to add." -ForegroundColor Green
    Write-Host ""
    Write-Host "Press any key to return to the main menu..." -ForegroundColor Yellow
    start-sleep -Seconds 1
    #$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  # Wait for any key press to return
    
}

# Main loop to control the menu flow
while ($true) {
    Show-Menu -currentSelection $currentSelection

    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    if ($key.VirtualKeyCode -eq 38 -and $currentSelection -gt 0) { # Up arrow
        $currentSelection--
    } elseif ($key.VirtualKeyCode -eq 40 -and $currentSelection -lt $options.Length - 1) { # Down arrow
        $currentSelection++
    } elseif ($key.VirtualKeyCode -eq 13) { # Enter key
        if ($currentSelection -eq $options.Length - 1) {
            break # Exit
        } elseif ($currentSelection -eq 0) {
            $history += "Create a New Domain"
            $submenuSelection = 0
            while ($true) {
                Show-NewDomainWizard -currentSelection $submenuSelection
                $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                if ($key.VirtualKeyCode -eq 38 -and $submenuSelection -gt 0) {
                    $submenuSelection--
                } elseif ($key.VirtualKeyCode -eq 40 -and $submenuSelection -lt $newDomainOptions.Length - 1) {
                    $submenuSelection++
                } elseif ($key.VirtualKeyCode -eq 13) {
                    if ($submenuSelection -eq $newDomainOptions.Length - 1) {
                        $history = @() # Clear history when going back to main menu
                        break # Go back to main menu
                    }
                    $history += $newDomainOptions[$submenuSelection]
                    Write-Host "You selected: $($newDomainOptions[$submenuSelection])" -ForegroundColor Green
                    Start-Sleep -Seconds 2
                }
            }
        } elseif ($currentSelection -eq 1) {
            $history += "Modify Existing Domains"
            $submenuSelection = 0
            while ($true) {
                Show-ModifyDomainWizard -currentSelection $submenuSelection
                $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                if ($key.VirtualKeyCode -eq 38 -and $submenuSelection -gt 0) {
                    $submenuSelection--
                } elseif ($key.VirtualKeyCode -eq 40 -and $submenuSelection -lt $modifyDomainOptions.Length - 1) {
                    $submenuSelection++
                } elseif ($key.VirtualKeyCode -eq 13) {
                    if ($submenuSelection -eq $modifyDomainOptions.Length - 1) {
                        $history = @() # Clear history when going back to main menu
                        break # Go back to main menu
                    }
                    $history += $modifyDomainOptions[$submenuSelection]
                    Write-Host "You selected: $($modifyDomainOptions[$submenuSelection])" -ForegroundColor Green
                    Start-Sleep -Seconds 2
                }
            }
        } elseif ($currentSelection -eq 2) {
            # "Other Options" was selected
            $history += "Other Options"
            Show-OtherOptions
        }
    }
}

Write-Host "Exiting..." -ForegroundColor Red
