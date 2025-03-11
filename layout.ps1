Clear-Host

# Sample data (replace with your own data)
$data = @(
    [PSCustomObject]@{VMName = 'ADA-CS1SITE'; State = 'Running'; Role = 'CAS'; MemoryGB = 10; DiskUsedGB = 176.60},
    [PSCustomObject]@{VMName = 'ADA-DC1'; State = 'Running'; Role = 'DC'; MemoryGB = 4; DiskUsedGB = 30.21},
    [PSCustomObject]@{VMName = 'ADA-PS1DPMP1'; State = 'Running'; Role = 'SiteSystem'; MemoryGB = 3; DiskUsedGB = 109.36},
    [PSCustomObject]@{VMName = 'ADA-W11CLIENT1'; State = 'Running'; Role = 'DomainMember'; MemoryGB = 4; DiskUsedGB = 37.19},
    [PSCustomObject]@{VMName = 'CON-W11CLIENT2'; State = 'Off'; Role = 'DomainMember'; MemoryGB = 4; DiskUsedGB = 20.02}
)

# Iterate through each row and alternate colors
$rowIndex = 0
foreach ($vm in $data) {
    # Check if the state is "Running" or "Off" and apply color accordingly
    $stateColor = if ($vm.State -eq "Running") {
        $psstyle.Foreground.Green  # Green for Running
    } elseif ($vm.State -eq "Off") {
        $psstyle.Foreground.Red  # Red for Off
    } else {
        $psstyle.Foreground.White  # Default to White for other states
    }

    # Alternate color for the row background
    if ($rowIndex % 2 -eq 0) {
        # Set background color for even rows (light gray)
        Write-Host ("{0,-20} {1,-20} {2,-15} {3,-10} {4,-10}" -f $vm.VMName, "$($stateColor)$($vm.State)$($psstyle.Reset)", $vm.Role, $vm.MemoryGB, $vm.DiskUsedGB)
    } else {
        # Set background color for odd rows (light blue)
        Write-Host ("{0,-20} {1,-20} {2,-15} {3,-10} {4,-10}" -f $vm.VMName, "$($stateColor)$($vm.State)$($psstyle.Reset)", $vm.Role, $vm.MemoryGB, $vm.DiskUsedGB)
    }
    
    # Increment row index
    $rowIndex++
}
