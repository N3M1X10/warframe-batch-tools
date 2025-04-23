@echo off

powershell -command "$connections = Get-NetTCPConnection | Where-Object { $_.RemotePort -ge 6695 -and $_.RemotePort -le 6705 }; if ($connections) {$connections | Out-File -FilePath '%~dp0connections.txt'} else {$proc=Get-Process -Name "Warframe.x64" -ErrorAction SilentlyContinue; if($proc){$procId = $proc.Id;$connections = Get-NetTCPConnection | Where-Object { $_.OwningProcess -eq $procId}; $connections | Out-File -FilePath '%~dp0pid-connections.txt'}}"
