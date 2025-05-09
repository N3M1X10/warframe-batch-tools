#path args

$scriptPath = $PSScriptRoot
$parentPath = Split-Path $scriptPath -Parent
$binPath = Join-Path $parentPath "bin"
$configPath = Join-Path $parentPath "config"

if (-not (Test-Path $binPath)) {
    New-Item -Path $binPath -ItemType Directory
}

if (-not (Test-Path $configPath)) {
    New-Item -Path $configPath -ItemType Directory
}

class ApiRequestClient{
    [string]$ApiUrl
    [string]$Method
    [string]$Endpoint
    [string]$Token
    [hashtable]$Headers
    [string]$Body

    ApiRequestClient([string]$apiUrl) {
        $this.ApiUrl = $apiUrl
        $this.Headers = @{}
        $this.Body = ""
    }

    [void] setRequestParameters([string]$method, [string]$endpoint, [string]$token = "", [hashtable]$headers = @{}, [string]$body = "") {
        $this.Method = $method
        $this.Endpoint = $endpoint
        $this.Token = $token
        $this.Headers = $headers
        $this.Body = $body
    }

    [Object] invokeApi() {
        $url = "$($this.ApiUrl)/$($this.Endpoint)"
        if ($this.Token) {
            $this.Headers["Authorization"] = "Bearer $($this.Token)"
        }
        try {
            $response = Invoke-RestMethod -Uri $url -Method $this.Method -Headers $this.Headers -Body $this.Body -ContentType "application/json" -Verbose
            return $response
        }
        catch {
            Write-Host "Request error: $_"
            return $null 
        }
    }

    # POST
    [Object] ins([string]$method, [string]$endpoint, [string]$token = "", [hashtable]$headers = @{}, [string]$body = "") {
        $this.setRequestParameters($method, $endpoint, $token, $headers, $body)
        return $this.InvokeApi()
    }

    # PATCH
    [Object] sec([string]$method, [string]$endpoint, [string]$token, [hashtable]$headers = @{}, [string]$body = "") {
        $this.setRequestParameters($method, $endpoint, $token, $headers, $body)
        return $this.InvokeApi()
    }

    # CONNECTION CHECKER
    [bool] checkConnection() {
        try {
            $this.SetRequestParameters("POST", "reg", "", @{}, "")
            $url = "$($this.ApiUrl)/$($this.Endpoint)"
            $response = Invoke-RestMethod -Uri $url -Method $this.Method -Headers $this.Headers -Body $this.Body -ContentType "application/json" -Verbose -TimeoutSec 10
            if ($response -ne $null) {
                return $true
            }
            else {
                return $false
            }
        }
        catch {
            Write-Host "Connection error: $_"
            return $false
        }
    }
}

# I should refactor this xD
function installAmnezia{
    $msiPath = Join-Path $binPath "amneziawg-amd64-1.0.0.msi"
    if (Get-Command msiexec.exe -ErrorAction SilentlyContinue){
        Write-Host "msiexec.exe found"
        Start-Process msiexec.exe -ArgumentList "/i", "`"$msiPath`"", "/quiet", "/norestart" -NoNewWindow -Wait
        Write-Host "AmneziaWG successfully installed."
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Powershell session updated"
    }   
    else{
        Write-Host "msiexec.exe not found"
        Write-Host "Please install awg manually"
        Read-Host "Press ENTER to close the window"
        exit 0
    }

}

function getWarframePort{
    $connections = Get-NetTCPConnection | Where-Object { $_.RemotePort -ge 6695 -and $_.RemotePort -le 6705 }
    if ($connections) {
        $remoteAdress = $connections | Select-Object -ExpandProperty RemoteAddress
        return $remoteAdress
    } 
    else {
        $proc=Get-Process -Name "Warframe.x64" -ErrorAction SilentlyContinue
        if($proc){
            $procId = $proc.Id
            $connections = Get-NetTCPConnection | Where-Object { $_.OwningProcess -eq $procId}

        $connectionsPath = Join-Path $parentPath "logs\connections.txt"
        $connections | Out-File -FilePath $connectionsPath
        }
        return "0.0.0.0/0, ::/0"
    }
}

function installService {
    $process = Start-Process "amneziawg" -ArgumentList "/installtunnelservice", "$configPath\awg0.conf" -PassThru -Verb RunAs
    $process.WaitForExit()
    if ($process.ExitCode -eq 0) {
        Write-Host "Service was installed successfully."
        return $true
    } else {
        Write-Host "Service installation failed."
        return $false
    }
}

function uninstallService {
    $process = Start-Process "amneziawg" -ArgumentList "/uninstalltunnelservice", "awg0" -PassThru -Verb RunAs
    $process.WaitForExit()
    if ($process.ExitCode -eq 0) {
        Write-Host "Service was removed successfully."
    } else {
        Write-Host "Service uninstallation failed."
    }
}


$hasAmnesia = Get-Command awg -ErrorAction SilentlyContinue
if (-not $hasAmnesia) {
    installAmnezia
}
else {
    $programName = "amneziawg.exe"
    if (Get-Command $programName -ErrorAction SilentlyContinue) {
        Start-Process $programName
    }

}

#CLIENT ARGS
$api = "https://api.cloudflareclient.com/v0i1909051800"
$client = [ApiRequestClient]::new($api)

#KEYS
$priv = if ($args[0]) { $args[0] } else { (awg genkey) }
$pub = if ($args[1]) { $args[1] } else { $priv | awg pubkey }

#SYS INFO
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$osType = if ($osInfo.Caption -like "*Windows*") { "windows" } else { "Unknown" }
$syslocale = Get-Culture

#REQUEST BODY
$body = @{
    install_id = ""
    tos = (Get-Date -UFormat "%Y-%m-%dT%H:%M:%S.000Z")
    key = $pub
    fcm_token = ""
    type = $osType
    locale = $syslocale
} | ConvertTo-Json


$testcon = $client.checkConnection()
$hasServiceInstalled = $false
$repeats = 0

if ($testcon -eq $false){
    do{
        if($testcon -eq $true){
            Write-Host "Connection established"
            break
        }
        else{
            Write-Host "Connection failed"
            if($hasServiceInstalled -eq $false){
                $hasServiceInstalled = installService
            }
            $testcon = $client.checkConnection()
            $repeats += 1
            Start-Sleep -Seconds 2
        }
    }
    while(-not $testcon -and $repeats -ne 10)
}

if ($testcon -eq $true){

    #REQUEST
    #$response = ins -method "POST" -endpoint "reg" -body $body
    $response = $client.ins("POST", "reg", "", @{}, $body)

    $id = $response.result.id
    $token = $response.result.token

    #$response = sec -method "PATCH" -endpoint "reg/$id" -token $token -body '{"warp_enabled":true}'
    $patchResponse = $client.sec("PATCH", "reg/$id", $token, @{}, '{"warp_enabled":true}')

    $peer_pub = $patchResponse.result.config.peers[0].public_key
    $client_ipv4 = $patchResponse.result.config.interface.addresses.v4
    $client_ipv6 = $patchResponse.result.config.interface.addresses.v6
    $allowips = getWarframePort

        $conf = @"
    [Interface]
    PrivateKey = ${priv}
    S1 = 0
    S2 = 0
    Jc = 120
    Jmin = 23
    Jmax = 911
    H1 = 1
    H2 = 2
    H3 = 3
    H4 = 4
    MTU = 1280
    Address = ${client_ipv4}, ${client_ipv6}
    DNS = 1.1.1.1, 2606:4700:4700::1111, 1.0.0.1, 2606:4700:4700::1001

    [Peer]
    PublicKey = ${peer_pub}
    AllowedIPs = ${allowips}
    Endpoint = engage.cloudflareclient.com:500
    "@
    $warpConfigPath = Join-Path $configPath "WARP_warframe_chat.conf"
    $conf | Out-File -FilePath $warpConfigPath

    Write-host "Generation sucessfull. Please check the config path."
}
else{
    Write-Host "An error occurred while generating the config. Please do this manually."
}

if($hasServiceInstalled -eq $true){
    uninstallService
}

Read-Host "Press ENTER to close the window"