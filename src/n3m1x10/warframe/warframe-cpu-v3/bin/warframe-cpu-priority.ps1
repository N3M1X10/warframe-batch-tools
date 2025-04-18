
# Params 
$GameProcName = "Warframe.x64"
$ClientProcName = "Warframe Launcher"
$Priority = "high"

function FindLauncher{
    param(
        [string]$LauncherDescName
    )

    #find all processes named launcher and catching errors
    try {
        $ClientProc = Get-Process -Name "Launcher" -ErrorAction Stop
    }
    catch {
        cls
        Write-Host "Processes 'Launcher' are not found"
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


# find process and priority application

function PriorityApplication{    
    param(
        [string]$GameProcName,
        [string]$ClientProcName,
        [string]$Priority
    )
    #priority table :)
    $priorityMapping = @{
        'low' = [System.Diagnostics.ProcessPriorityClass]::Idle
        'BelowNormal' = [System.Diagnostics.ProcessPriorityClass]::BelowNormal
        'normal' = [System.Diagnostics.ProcessPriorityClass]::Normal
        'AboveNormal' = [System.Diagnostics.ProcessPriorityClass]::AboveNormal
        'high' = [System.Diagnostics.ProcessPriorityClass]::High
        'realtime' = [System.Diagnostics.ProcessPriorityClass]::RealTime
    }
    $BreakOccured = $false
    $HasWindow = $false

    do {
        Start-Sleep -Seconds 1
        $GameProc = Get-Process -Name $GameProcName -ErrorAction SilentlyContinue
        $HasLauncher = FindLauncher -LauncherDescName $ClientProcName

        #If launcher found, but not game process
        if ($HasLauncher -and -not $GameProc){
            cls
            Write-Host "Process Warframe.x64.exe not found"
            Write-Host "Please, launch Warframe"
        }

        #If process window and game process was found, but not launcher
        elseif (-not $HasLauncher -and $GameProc -and $GameProc.MainWindowHandle -ne 0){
            $HasWindow = $true
            $BreakOccured = $false
            Write-Host "Process has been found"
            $PriorityClass = $priorityMapping[$Priority.ToLower()]
            $GameProc.PriorityClass = $PriorityClass
            Write-Host "Priority for $GameProcName.exe has been changed on $Priority"
        }

        #If launcher and game process was found, but process hasn't window
        elseif ($HasLauncher -and $GameProc -and -not ($GameProc.MainWindowHandle -ne 0)){
            cls
            Write-Host "Process Warframe.x64.exe has no window"
            Write-Host "Im trying to find him again . . ."
        }

        #If launcher and game process are not found
        elseif (-not $HasLauncher -and -not $GameProc){
            Write-Host "Launcher not found. Script termination..."
            $BreakOccured = $true
            break
        }

    } while (-not $HasWindow)

    return $BreakOccured
}


# launcher launch check (Don't touch what works) xD
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


# interrupt check (trash part)
if ($BreakFlag){
    Write-Host "Script was interrupted"
}
else{
    Write-Host "Script completed successfully"
}
