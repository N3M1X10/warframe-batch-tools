# Params
$global:myScriptName = $($MyInvocation.MyCommand.Name.Trim())
$scriptPath = $PSScriptRoot

$global:ownLogPath = Join-Path -Path $scriptPath -ChildPath "autorestart-scrobbler.log"

$restarterPath = Resolve-Path -Path "$scriptPath\..\..\.."
$restart_warframe_script = "restart-warframe-united.bat"
$restart_warframe_batch_path = Join-Path -Path $restarterPath -ChildPath $restart_warframe_script

$ScrobblerJobArgs_targetStrings = @(
    'The connection to the host has been lost'
    'ENCMGR: InitializeHostMigration'
    'ENCMGR: StartHostMigrationEncounters - finished starting encounters after migration!'
    'HOST MIGRATION: local client trying to join new host'
    'Host migration timed out'
    'MIGRATION: Hosting'
)

$ScrobblerJobArgs_exceptionStrings = @(
    'ENCMGR: FinalizeHostMigration - no encounter info for migration!'
    'IRC'
)

$GameProcName = "Warframe.x64"
$ClientProcName = "Warframe Launcher"

function global:Write-Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    $logMessage | Out-File -FilePath $global:ownLogPath -Append -Encoding utf8
}



function interrupt {
    param (
        $msg = "Some Error"
        )
    Write-Host $msg -foregroundcolor red
    Write-Log $msg
    exit
}

# starting bell
# [console]::beep(1600,200)
# [console]::beep(1600,200)
Write-Log ""
Write-Log "Script started"

# interrupt("Hello, i am a dumb script by the dumb coder. Just test closing")

if (-not (Test-Path $restart_warframe_batch_path)) {
    Write-Host "Batch file not found: $restart_warframe_batch_path" -ForegroundColor Red
    interrupt("Batch file $restart_warframe not found. Expected path: '$restart_warframe_batch_path'. Script autorestarter was interrupted.")
}


function RestartGame {
    Start-Process -FilePath $restart_warframe_batch_path -Verb RunAs
}


function StartAutoCloser {
    Write-Host "Started autoexit scanner..." -ForegroundColor Cyan
    Write-Log "Started autoexit scanner..."
    $autocloser_job = Start-Job -ScriptBlock {
        param($GameProcName, $ClientProcName)
        
        function Write-Log {
            param (
                [string]$Message
            )
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $logMessage = "[$timestamp] $Message"
            $logMessage | Out-File -FilePath $using:ownLogPath -Append -Encoding utf8
        }

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
            Start-Sleep -Milliseconds 500
            $HasLauncher = FindLauncher -LauncherDescName $ClientProcName
            $GameProc = Get-Process -Name $GameProcName -ErrorAction SilentlyContinue
            # Write-Log "Launcher: $HasLauncher, Game: $($GameProc -ne $null)"
        } while ($HasLauncher -or $GameProc)
        Write-Log "No launcher or game found. Exiting..."
        exit
    } -ArgumentList $GameProcName, $ClientProcName
    return $autocloser_job
}


function StartScrobbler {
    $scrobbler_job = Start-Job -ScriptBlock {
        param(
            $restart_warframe_batch_path,
            $target_strings, # Массив строк для поиска
            $exception_strings # Массив строк для поиска
        )

        # log writer
        function Write-Log {
            param (
                [string]$Message
            )
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $logMessage = "[$timestamp] $Message"
            $logMessage | Out-File -FilePath $using:ownLogPath -Append -Encoding utf8
        }

        # check ee log
        $logPath = "$env:LOCALAPPDATA\Warframe\EE.log"
        if (-not (Test-Path $logPath)) {
            Write-Log "[SCROBBLER] Log file not found: $logPath"
            Write-Log "[SCROBBLER] Scrobbler was interrupted"
            exit
        }

        # cycle log reader
        Get-Content -Path $logPath -Tail 1 -Wait | ForEach-Object {
            $logresult = $_

            $shouldRestart = $false
            $shouldInterrupt = $false

            # chat user commands check
            if (
                ($logresult -match '_stop-ars') -or
                ($logresult -match '_cancel-ars')
                ) {
                if (-not ($logresult -match 'No online player found with alias')) {
                    Write-Log "[SCROBBLER][WARNING] Have found string like command to stop the script. But it not from the invitations menu"
                } else {
                    Write-Log "[SCROBBLER] Found the user command to stop the Scrobbler"
                    Write-Log "[SCROBBLER] This line: $logresult"
                    msg * "[$using:myScriptName] Found the user command to stop the Scrobbler"
                    $shouldInterrupt = $true
                }
            }
            
            if (
                ($logresult -match '_reboot') -or
                ($logresult -match '_restart')
            ) {
                if (-not ($logresult -match 'No online player found with alias')) {
                    Write-Log "[SCROBBLER][WARNING] Have found string like command to restart the game. But it not from the invitations menu"
                } else {
                    Write-Log "[SCROBBLER][IT MATCHES] I have found the user command to restart the game in the log!"
                    Write-Log "[SCROBBLER][IT MATCHES] This line: '$logresult'"
                    $shouldRestart = $true
                }
            }

            # checking the target strings in log
            foreach ($target_string in $target_strings) {
                # Write-Log "Matching: '$target_string' in target_strings"
                if ($logresult -match $target_string) {
                    Write-Log "[SCROBBLER] I have found the target string in the log!"
                    Write-Log "[SCROBBLER] This line: $logresult"
                    $shouldRestart = $true
                    # Проверка на исключение
                    foreach ($exception_string in $exception_strings) {
                        # Если в строке есть исключения
                        if ($logresult -match $exception_string) {
                            Write-Log "[SCROBBLER][WARNING] But this is a string that contains: '$exception_string' exception"
                            Write-Log "[SCROBBLER] The restarting has been canceled"
                            $shouldRestart = $false
                        }
                    }
                }
            }

            # final checks
            if ($shouldRestart) {
                Write-Log ""
                Write-Log "[SCROBBLER][IT MATCHES] !!!!! I HAVE FOUND THE TARGET LINE !!!!!"
                Write-Log "[SCROBBLER][IT MATCHES] This line: $logresult"
                Write-Log ""
                Write-Log "I'm gonna restarting the game. Starting: '$restart_warframe_batch_path'"
                Start-Process -FilePath $restart_warframe_batch_path -Verb RunAs
                $shouldInterrupt = $true
            }

            if ($shouldInterrupt) {
                Write-Log "[SCROBBLER] Scrobbler was interrupted"
                exit
            }
        }
    } -ArgumentList $restart_warframe_batch_path, @($ScrobblerJobArgs_targetStrings), @($ScrobblerJobArgs_exceptionStrings)  # Передаем первые три элемента как массив строк и последний как путь к батнику

    Write-Host 'Started Host Migration scanner for auto restart the game...' -Foregroundcolor Cyan
    Write-Log 'Started Host Migration scanner for auto restart the game...'
    return $scrobbler_job
}



function JobsCycle {
    param($scrobbler_job, $autocloser_job)
    # if (-not $scrobbler_job -or -not $autocloser_job) {
    #     interrupt("ERROR: One or both jobs are not created! Script was interrupted")
    # }

    try {
        while ($true) {
            $autocloser_jobstate = (Get-Job -Id $autocloser_job.Id -ErrorAction Stop).State
            $scrobbler_jobstate = (Get-Job -Id $scrobbler_job.Id -ErrorAction Stop).State

            # Write-Log "AutoCloser: $autocloser_jobstate, Scrobbler: $scrobbler_jobstate"

            if ($autocloser_jobstate -eq 'Completed' -or $scrobbler_jobstate -eq 'Completed') {
                Write-Log "One of the jobs has completed. Stopping jobs..."
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
        Write-Log "ERROR: $_"
    }
    Write-Host "Jobs completed. Main script exiting..." -ForegroundColor Green
    Write-Log "Jobs completed. Main script exiting..."
    # Start-Sleep -s 1
    # [console]::beep(400,600)
    exit
}




$scrobbler_job = StartScrobbler
$autocloser_job = StartAutoCloser
JobsCycle -scrobbler_job $scrobbler_job -autocloser_job $autocloser_job
