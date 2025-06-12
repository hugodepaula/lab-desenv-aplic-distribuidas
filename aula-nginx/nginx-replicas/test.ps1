Set-Location docker

$serviceStatus = docker-compose.exe ps | Select-String -Pattern "nginx-replicas" | Select-String -Pattern "Up"
if ($null -ne $serviceStatus) {
    Write-Host "O serviço já está rodando. Parando o serviço..."
    docker-compose down
}

# docker-compose build --no-cache
docker-compose up -d
Start-Sleep -Seconds 5

# Testa se o serviço já está rodando
$serviceStatus = docker-compose ps | Select-String -Pattern "nginx-replicas" | Select-String -Pattern "Up"

while ($null -eq $serviceStatus) {
    Write-Host "Espera o serviço inicializar..."
    Start-Sleep -Seconds 5
    $serviceStatus = docker-compose ps | Select-String -Pattern "nginx-replicas" | Select-String -Pattern "Up"

}



Set-Location ..
# Testa o serviço fazendo 10 requisições

for ($i = 1; $i -le 10; $i++)
{
    curl -H 'Cache-Control: no-cache, no-store' http://localhost:80
    Write-Host ""  # Imprime uma linha em branco
    # Start-Sleep -Seconds 1
}