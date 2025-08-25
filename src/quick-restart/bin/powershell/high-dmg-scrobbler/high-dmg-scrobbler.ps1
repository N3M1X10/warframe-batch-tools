
# Params
$enableLogging = 0

$global:myScriptName = $($MyInvocation.MyCommand.Name.Trim())
$scriptPath = $PSScriptRoot
$ownLogPath = Join-Path -Path $scriptPath -ChildPath "high-dmg-scrobbler.log"

$target_strings = @(
    'high dmg'
    'Game [Warning]:  high dmg:'
    'Damage too high'
    'GOT NEGATIVE AMOUNT DAMAGE IN PROCESS TEXT'
)

$exception_strings = @(
)

# log writer
function Write-Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    if ($enableLogging -eq 1) {
        $logMessage | Out-File -FilePath $ownLogPath -Append -Encoding utf8
    }
}


Write-Host "Scanning for high-dmg messages in 'EE.log'..." -Fore Cyan
Write-Log "Script started"


if ($enableLogging -eq 1) {
    Write-Host "[note] Logging is enabled"
} else {
    Write-Host "[note] Logging is disabled"
}

# check ee log
$logPath = "$env:LOCALAPPDATA\Warframe\EE.log"
if (-not (Test-Path $logPath)) {
    Write-Log "Log file not found: $logPath"
    Write-Log "Script was interrupted"
    exit
}


# cycle log reader
Get-Content -Path $logPath -Tail 1 -Wait | ForEach-Object {
    $logresult = $_
    # checking the target strings in log
    foreach ($target_string in $target_strings) {
        if ($logresult -match $target_string) {
            Write-Host "$logresult" -Fore DarkGreen
            Write-Log "$logresult"
            ## Exceptions checking
            foreach ($exception_string in $exception_strings) {
                if ($logresult -match $exception_string) {
                    # Write-Log "Found exception string"
                }
            }
        }
    }
}

