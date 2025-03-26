# Iniciar contenedores con Docker Compose
docker-compose up -d --build

# Crear carpeta logs si no existe
if (!(Test-Path logs)) {
    New-Item -ItemType Directory -Path logs | Out-Null
}

# Definir tamaño máximo (10MB)
$MAX_SIZE = 10 * 1024 * 1024
$logFile = "logs\app.log"

# Verificar tamaño del log y rotar si es necesario
if (Test-Path $logFile) {
    $fileSize = (Get-Item $logFile).Length
    if ($fileSize -ge $MAX_SIZE) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        Rename-Item -Path $logFile -NewName "logs\app-$timestamp.log"
        New-Item -ItemType File -Path $logFile | Out-Null
    }
}

# Guardar logs en el archivo
Start-Process -NoNewWindow -FilePath "docker-compose" -ArgumentList "logs -f" -RedirectStandardOutput $logFile

Write-Host "Odoo y PostgreSQL han sido iniciados correctamente."
