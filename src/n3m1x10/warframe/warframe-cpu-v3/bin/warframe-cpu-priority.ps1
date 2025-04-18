$GameProcName = "Warframe.x64"
$ClientProcName = "Warframe Launcher"
$Priority = "high"

function FindLauncher{
    param(
        [string]$LauncherDescName
    )
    try {
        $ClientProc = Get-Process -Name "Launcher" -ErrorAction Stop
    }
    catch {
        cls
        Write-Host "Process '$LauncherDescName' not found"
        return $false
    }

    foreach($obj in $ClientProc){
        if($obj.Description -eq $LauncherDescName){
            Write-Host "Client $LauncherDescName was found"
            return $true
        }
    }
    return $false
}

function PriorityApplication{    
    param(
        [string]$GameProcName,
        [string]$ClientProcName,
        [string]$Priority
    )

    $BreakOccured = $false
    $HasWindow = $false
    do {
        Start-Sleep -Seconds 1
        $GameProc = Get-Process -Name $GameProcName -ErrorAction SilentlyContinue
        $HasLauncher = FindLauncher -LauncherDescName $ClientProcName
        if ($HasLauncher){
            if($GameProc) {
                if ($GameProc -and $GameProc.MainWindowHandle -ne 0) {
                    $HasWindow = $true
                    $BreakOccured = $false
                    Write-Host "Process has been found"
                    $GameProc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::$Priority
                    Write-Host "Priority for $GameProcName.exe has been changed on Priority"
                }
                else{
                    cls
                    Write-Host "Process Warframe.x64.exe has no window"
                    Write-Host "Im trying to find him again . . ."
                }
            } 
            else{
                cls
                Write-Host "Process Warframe.x64.exe not found"
                Write-Host "Please, launch Warframe"
            }
        }
        else{
            Write-Host "Launcher not found. Script termination..."
            $BreakOccured = $true
            break
        }
    } while (-not $HasWindow)

    return $BreakOccured
}

do{
    Start-Sleep -Seconds 1
    $HasLauncher = FindLauncher -LauncherDescName $ClientProcName
    if ($HasLauncher){
        cls
        Write-Host "Client $ClientProcName was found"
    }
    else {
        Write-Host "Please launch $ClientProcName"
    }
} while (-not $HasLauncher)

$BreakFlag = PriorityApplication -GameProcName $GameProcName -ClientProcName $ClientProcName -Priority $Priority

if ($BreakFlag){
    Write-Host "Script was interrupted"
}
else{
    Write-Host "Script completed successfully"
}
