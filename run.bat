@echo off
setlocal enabledelayedexpansion

:: Iniciar contenedores con Docker Compose
docker-compose up -d --build

:: Crear carpeta de logs si no existe
if not exist logs mkdir logs

:: Establecer permisos (solo necesario si usas WSL o Git Bash)
:: No es necesario en Windows puro

:: Definir tamaño máximo en bytes (10MB)
set /a MAX_SIZE=10*1024*1024

:: Verificar si el archivo logs\app.log existe y si supera el tamaño máximo
if exist logs\app.log (
    for %%F in (logs\app.log) do set FILE_SIZE=%%~zF
    if !FILE_SIZE! GEQ %MAX_SIZE% (
        ren logs\app.log app-!DATE:~10,4!!DATE:~4,2!!DATE:~7,2!!TIME:~0,2!!TIME:~3,2!!TIME:~6,2!.log
        type nul > logs\app.log
    )
)

:: Guardar logs en el archivo
start /b docker-compose logs -f >> logs\app.log

echo Odoo y PostgreSQL han sido iniciados correctamente.
