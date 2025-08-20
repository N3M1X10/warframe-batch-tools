# Params
$scriptPath = $PSScriptRoot
$restarterPath = Resolve-Path -Path "$scriptPath\..\..\.."
$restart_warframe_script = "restart-warframe-united.bat"

$restart_warframe_batch_path = Join-Path -Path $restarterPath -ChildPath $restart_warframe_script
$target_string_1 = 'HOST MIGRATION'
$target_string_2 = 'Host migration'
$target_string_3 = 'The connection to the host has been lost'

$GameProcName = "Warframe.x64"
$ClientProcName = "Warframe Launcher"

# [console]::beep(1600,200)
# [console]::beep(1600,200)

if (-not (Test-Path $restart_warframe_batch_path)) {
    Write-Host "Batch file not found: $restart_warframe_batch_path" -ForegroundColor Red
    msg * "Batch file $restart_warframe not found. Script autorestarter was interrupted."
    msg * "Expected path: $restart_warframe_batch_path"
    exit
}


function RestartGame {
    Start-Process -FilePath $restart_warframe_batch_path -Verb RunAs
}


function StartScrobbler {
    Write-Host 'Started Host Migration scanner for auto restart the game...' -ForegroundColor Cyan
    $scrobbler_job = Start-Job -ScriptBlock {
        param(
            $target_string_1,
            $target_string_2,
            $target_string_3,
            $restart_warframe_batch_path
        )
        $logPath = "$env:LOCALAPPDATA\Warframe\EE.log"
        if (-not (Test-Path $logPath)) {
            Write-Host "Log file not found: $logPath" -ForegroundColor Red
            exit
        }
        Get-Content -Path $logPath -Tail 1 -Wait | ForEach-Object {
            $logresult = $_
            $time = (Get-Date).ToString('HH:mm:ss')
            if ($logresult -match $target_string_1 -or $logresult -match $target_string_2 -or $logresult -match $target_string_3) {
                Write-Host "[$time] I HAVE FOUND THE TARGET LINE" -ForegroundColor Yellow
                Start-Process -FilePath $restart_warframe_batch_path -Verb RunAs
                exit
            }
        }
    } -ArgumentList $target_string_1, $target_string_2, $target_string_3, $restart_warframe_batch_path
    return $scrobbler_job
}



function StartAutoCloser {
    Write-Host "Started async autoexit function" -ForegroundColor Cyan
    $autocloser_job = Start-Job -ScriptBlock {
        param($GameProcName, $ClientProcName)
        function FindLauncher {
            param($LauncherDescName)
            try {
                $ClientProc = Get-Process -Name "Launcher" -ErrorAction Stop
                foreach($obj in $ClientProc) {
                    if($obj.Description -eq $LauncherDescName) {
                        return $true
                    }
                }
            }
            catch {}
            return $false
        }
        do {
            Start-Sleep -Seconds 1
            $HasLauncher = FindLauncher -LauncherDescName $ClientProcName
            $GameProc = Get-Process -Name $GameProcName -ErrorAction SilentlyContinue
            Write-Host "Launcher: $HasLauncher, Game: $($GameProc -ne $null)"
        } while ($HasLauncher -or $GameProc)
        Write-Host "No launcher or game found. Exiting..."
        exit
    } -ArgumentList $GameProcName, $ClientProcName
    return $autocloser_job
}


function JobsCycle {
    param($scrobbler_job, $autocloser_job)
    if (-not $scrobbler_job -or -not $autocloser_job) {
        Write-Host "ERROR: One or both jobs are not created!" -ForegroundColor Red
        exit
    }
    try {
        while ($true) {
            $autocloser_jobstate = (Get-Job -Id $autocloser_job.Id -ErrorAction Stop).State
            $scrobbler_jobstate = (Get-Job -Id $scrobbler_job.Id -ErrorAction Stop).State
            if ($autocloser_jobstate -eq 'Completed' -or $scrobbler_jobstate -eq 'Completed') {
                Stop-Job $scrobbler_job -ErrorAction SilentlyContinue
                Stop-Job $autocloser_job -ErrorAction SilentlyContinue
                Remove-Job $scrobbler_job -ErrorAction SilentlyContinue
                Remove-Job $autocloser_job -ErrorAction SilentlyContinue
                break
            }
            Start-Sleep -Milliseconds 1000
        }
    }
    catch {
        Write-Host "ERROR: $_" -ForegroundColor Red
    }
    # [console]::beep(400,400)
    Write-Host "Jobs completed. Exiting..." -ForegroundColor Green
    exit
}



$scrobbler_job = StartScrobbler
$autocloser_job = StartAutoCloser
JobsCycle -scrobbler_job $scrobbler_job -autocloser_job $autocloser_job
