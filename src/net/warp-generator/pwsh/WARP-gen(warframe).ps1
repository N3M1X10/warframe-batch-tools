#path args

$scriptPath = $PSScriptRoot
$parentPath = Split-Path $scriptPath -Parent
$binPath = Join-Path $parentPath "bin"

if (-not (Test-Path $binPath)) {
    New-Item -Path $binPath -ItemType Directory
}

function downloadAmnezia{
    $arch = $env:PROCESSOR_ARCHITECTURE.ToLower()
    $downloadUrl = "https://github.com/amnezia-vpn/amneziawg-windows-client/releases/download/1.0.0/amneziawg-$arch-1.0.0.msi"
    $outputPath = "$binPath\amneziawg-$arch-1.0.0.msi"

    Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath
    # cd $binPath
    # Start-Process msiexec.exe -ArgumentList "/i", "amneziawg-$arch-1.0.0.msi", "/quiet", "/norestart" -NoNewWindow -Wait


    $msiPath = Join-Path $binPath "amneziawg-$arch-1.0.0.msi"
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
    

    # [System.Reflection.Assembly]::LoadWithPartialName("System.Management.Automation") | Out-Null

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



$hasAmnesia = Get-Command awg -ErrorAction SilentlyContinue
if (-not $hasAmnesia) {
    downloadAmnezia
}
else {
    $programName = "amneziawg.exe"
    if (Get-Command $programName -ErrorAction SilentlyContinue) {
        Start-Process $programName
    }

}

#ARGS
$api = "https://api.cloudflareclient.com/v0i1909051800"
$priv = if ($args[0]) { $args[0] } else { (awg genkey) }
$pub = if ($args[1]) { $args[1] } else { $priv | awg pubkey }
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$osType = if ($osInfo.Caption -like "*Windows*") { "windows" } else { "Unknown" }

function ins {
    param (
        [string]$method,
        [string]$endpoint,
        [string]$token = "",
        [hashtable]$headers = @{},
        [string]$body = ""
    )

    $url = "${api}/$endpoint"

    if ($token) {
        $headers["Authorization"] = "Bearer $token"
    }

    $response = Invoke-RestMethod -Uri $url -Method $method -Headers $headers -Body $body -ContentType "application/json"
    return $response
}


function sec {
    param (
        [string]$method,
        [string]$endpoint,
        [string]$token,
        [hashtable]$headers = @{},
        [string]$body = ""
    )

    return ins -method $method -endpoint $endpoint -token $token -headers $headers -body $body
}


$body = @{
    install_id = ""
    tos = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ")
    key = $pub
    fcm_token = ""
    type = $osType
    locale = "en_US"
} | ConvertTo-Json


$response = ins -method "POST" -endpoint "reg" -body $body

$id = $response.result.id
$token = $response.result.token
$response = sec -method "PATCH" -endpoint "reg/$id" -token $token -body '{"warp_enabled":true}'

$peer_pub = $response.result.config.peers[0].public_key
$client_ipv4 = $response.result.config.interface.addresses.v4
$client_ipv6 = $response.result.config.interface.addresses.v6
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


$warpConfigPath = Join-Path $parentPath "bin\WARP_warframe_chat.conf"
$conf | Out-File -FilePath $warpConfigPath

Read-Host "Press ENTER to close the window"