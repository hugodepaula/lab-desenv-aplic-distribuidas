docker-compose.exe up -d

Start-Sleep -Seconds 5
# Ensure the service is running
$serviceStatus = docker-compose.exe ps | Select-String -Pattern "nginx" | Select-String -Pattern "Up"

while ($null -eq $serviceStatus) {
    Write-Host "Waiting for service to start..."
    Start-Sleep -Seconds 5
    $serviceStatus = docker-compose.exe ps | Select-String -Pattern "nginx" | Select-String -Pattern "Up" 
  
}

# Test the service by making 10 requests

for ($i = 1; $i -le 10; $i++)
{
    curl -H 'Cache-Control: no-cache, no-store' http://localhost:8080
    Write-Host ""  # Print an empty line
    Start-Sleep -Seconds 2
}